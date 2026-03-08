import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

void main() {
  late Box box;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<Map>('habits_${DateTime.now().millisecondsSinceEpoch}');
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveHabitRepository', () {
    test('처음에는 습관 목록이 비어 있다', () async {
      final repo = HiveHabitRepository(box);
      final habits = await repo.getHabits(userId: 'uid-1');
      expect(habits, isEmpty);
    });

    test('addHabit: 추가 후 목록에 포함', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repo.addHabit(habit);
      final habits = await repo.getHabits(userId: 'uid-1');
      expect(habits.length, equals(1));
      expect(habits.first.name, equals('운동'));
    });

    test('getHabits: 다른 userId의 습관은 반환하지 않는다', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repo.addHabit(habit);
      final habits = await repo.getHabits(userId: 'uid-2');
      expect(habits, isEmpty);
    });

    test('deleteHabit: 삭제 후 목록에서 제거', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repo.addHabit(habit);
      await repo.deleteHabit(habitId: 'h-1', userId: 'uid-1');
      final habits = await repo.getHabits(userId: 'uid-1');
      expect(habits, isEmpty);
    });

    test('checkIn: 체크인 후 Checkin 반환 (기본 10포인트)', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repo.addHabit(habit);
      final checkin = await repo.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );
      expect(checkin.carrotPoints, equals(10));
      expect(checkin.habitId, equals('h-1'));
    });

    test('addHabit: targetDays와 icon이 저장 후 복원됨', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-2',
        userId: 'uid-1',
        name: '독서',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
        targetDays: [0, 2, 4],
        icon: '📚',
      );
      await repo.addHabit(habit);
      final habits = await repo.getHabits(userId: 'uid-1');
      expect(habits.first.targetDays, equals([0, 2, 4]));
      expect(habits.first.icon, equals('📚'));
    });

    test('updateHabit: 변경된 targetDays와 icon이 저장됨', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-3',
        userId: 'uid-1',
        name: '명상',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repo.addHabit(habit);
      final updated = habit.copyWith(targetDays: [1, 3, 5], icon: '🧘');
      await repo.updateHabit(updated);
      final habits = await repo.getHabits(userId: 'uid-1');
      expect(habits.first.targetDays, equals([1, 3, 5]));
      expect(habits.first.icon, equals('🧘'));
    });

    test('getCheckins: 체크인 후 목록에서 조회 가능', () async {
      final repo = HiveHabitRepository(box);
      await repo.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );
      final checkins = await repo.getCheckins(habitId: 'h-1', userId: 'uid-1');
      expect(checkins.length, equals(1));
      expect(checkins.first.habitId, equals('h-1'));
      expect(checkins.first.date.day, equals(7));
    });

    test('getCheckins: Box 재생성 후에도 체크인 복원됨 (영속성)', () async {
      final repo = HiveHabitRepository(box);
      await repo.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );
      final repo2 = HiveHabitRepository(box);
      final checkins = await repo2.getCheckins(habitId: 'h-1', userId: 'uid-1');
      expect(checkins.length, equals(1));
    });

    test('deleteHabit: 삭제 시 관련 체크인도 함께 삭제', () async {
      final repo = HiveHabitRepository(box);
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repo.addHabit(habit);
      await repo.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );
      await repo.deleteHabit(habitId: 'h-1', userId: 'uid-1');
      final checkins = await repo.getCheckins(habitId: 'h-1', userId: 'uid-1');
      expect(checkins, isEmpty);
    });

    test('checkIn: 7번째 체크인 시 15포인트 (streakDay=6)', () async {
      final repo = HiveHabitRepository(box);
      for (int i = 0; i < 6; i++) {
        await repo.checkIn(
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 1 + i),
        );
      }
      final checkin7 = await repo.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );
      expect(checkin7.streakDay, equals(6));
      expect(checkin7.carrotPoints, equals(15));
    });

    test('checkIn: 같은 날 중복 체크인 시 예외 발생', () async {
      final repo = HiveHabitRepository(box);
      await repo.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );
      expect(
        () => repo.checkIn(
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 7),
        ),
        throwsException,
      );
    });
  });
}
