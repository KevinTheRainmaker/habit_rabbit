import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

void main() {
  late InMemoryHabitRepository repository;

  setUp(() {
    repository = InMemoryHabitRepository();
  });

  group('InMemoryHabitRepository', () {
    test('처음에는 습관 목록이 비어 있다', () async {
      final habits = await repository.getHabits(userId: 'uid-1');
      expect(habits, isEmpty);
    });

    test('addHabit: 추가 후 목록에 포함된다', () async {
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );

      await repository.addHabit(habit);
      final habits = await repository.getHabits(userId: 'uid-1');

      expect(habits.length, equals(1));
      expect(habits.first.name, equals('운동'));
    });

    test('getHabits: 다른 userId의 습관은 반환하지 않는다', () async {
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repository.addHabit(habit);

      final habits = await repository.getHabits(userId: 'uid-2');

      expect(habits, isEmpty);
    });

    test('checkIn: 체크인 후 Checkin 반환 (기본 10포인트)', () async {
      final checkin = await repository.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(checkin.habitId, equals('h-1'));
      expect(checkin.carrotPoints, equals(10));
    });

    test('checkIn: 같은 날 중복 체크인 시 예외 발생', () async {
      await repository.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(
        () => repository.checkIn(
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 7),
        ),
        throwsException,
      );
    });
  });
}
