import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/firestore_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreHabitRepository repo;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repo = FirestoreHabitRepository(fakeFirestore);
  });

  final testHabit = Habit(
    id: 'h1',
    userId: 'u1',
    name: '운동',
    createdAt: DateTime(2026, 3, 10),
    isActive: true,
  );

  group('addHabit', () {
    test('habit을 Firestore에 저장하고 반환', () async {
      final result = await repo.addHabit(testHabit);
      expect(result, testHabit);

      final doc = await fakeFirestore
          .collection('users')
          .doc('u1')
          .collection('habits')
          .doc('h1')
          .get();
      expect(doc.exists, isTrue);
      expect(doc['name'], '운동');
    });
  });

  group('getHabits', () {
    test('빈 컬렉션이면 빈 리스트 반환', () async {
      final habits = await repo.getHabits(userId: 'u1');
      expect(habits, isEmpty);
    });

    test('userId로 habit 목록 반환', () async {
      await repo.addHabit(testHabit);
      await repo.addHabit(
        Habit(
          id: 'h2',
          userId: 'u1',
          name: '독서',
          createdAt: DateTime(2026, 3, 10),
          isActive: true,
        ),
      );
      // 다른 유저의 habit은 포함되지 않음
      await repo.addHabit(
        Habit(
          id: 'h3',
          userId: 'u2',
          name: '명상',
          createdAt: DateTime(2026, 3, 10),
          isActive: true,
        ),
      );

      final habits = await repo.getHabits(userId: 'u1');
      expect(habits.length, 2);
      expect(habits.map((h) => h.id), containsAll(['h1', 'h2']));
    });
  });

  group('updateHabit', () {
    test('habit 정보 업데이트', () async {
      await repo.addHabit(testHabit);
      final updated = testHabit.copyWith(name: '달리기', isActive: false);
      await repo.updateHabit(updated);

      final doc = await fakeFirestore
          .collection('users')
          .doc('u1')
          .collection('habits')
          .doc('h1')
          .get();
      expect(doc['name'], '달리기');
      expect(doc['isActive'], false);
    });
  });

  group('deleteHabit', () {
    test('habit과 관련 checkin 삭제', () async {
      await repo.addHabit(testHabit);
      await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );

      await repo.deleteHabit(habitId: 'h1', userId: 'u1');

      final habitDoc = await fakeFirestore
          .collection('users')
          .doc('u1')
          .collection('habits')
          .doc('h1')
          .get();
      expect(habitDoc.exists, isFalse);

      final checkins = await fakeFirestore
          .collection('users')
          .doc('u1')
          .collection('checkins')
          .where('habitId', isEqualTo: 'h1')
          .get();
      expect(checkins.docs, isEmpty);
    });
  });

  group('checkIn', () {
    test('첫 번째 체크인은 streakDay 0', () async {
      final checkin = await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );
      expect(checkin.streakDay, 0);
      expect(checkin.habitId, 'h1');
      expect(checkin.userId, 'u1');
    });

    test('두 번째 체크인은 streakDay 1', () async {
      await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );
      final checkin = await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 11),
      );
      expect(checkin.streakDay, 1);
    });

    test('같은 날 중복 체크인 시 예외', () async {
      await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );
      expect(
        () => repo.checkIn(
          habitId: 'h1',
          userId: 'u1',
          date: DateTime(2026, 3, 10),
        ),
        throwsException,
      );
    });
  });

  group('getCheckins', () {
    test('체크인 목록 반환', () async {
      await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );
      await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 11),
      );

      final checkins = await repo.getCheckins(habitId: 'h1', userId: 'u1');
      expect(checkins.length, 2);
    });

    test('habitId/userId가 다른 체크인은 제외', () async {
      await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );
      await repo.checkIn(
        habitId: 'h2',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );

      final checkins = await repo.getCheckins(habitId: 'h1', userId: 'u1');
      expect(checkins.length, 1);
    });
  });
}
