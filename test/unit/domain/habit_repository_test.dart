import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    registerFallbackValue(Habit(
      id: 'h-1',
      userId: 'uid-1',
      name: '운동',
      createdAt: DateTime(2026, 3, 7),
      isActive: true,
    ));
  });

  group('HabitRepository', () {
    test('getHabits: 사용자 습관 목록 반환', () async {
      final habits = [
        Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true),
      ];
      when(() => repository.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => habits);

      final result = await repository.getHabits(userId: 'uid-1');

      expect(result, equals(habits));
    });

    test('addHabit: 습관 추가 후 반환', () async {
      final habit = Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true);
      when(() => repository.addHabit(any())).thenAnswer((_) async => habit);

      final result = await repository.addHabit(habit);

      expect(result.name, equals('운동'));
    });

    test('checkIn: 체크인 후 Checkin 반환', () async {
      final checkin = Checkin(id: 'c-1', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 7), streakDay: 0);
      when(() => repository.checkIn(habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 7)))
          .thenAnswer((_) async => checkin);

      final result = await repository.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(result.carrotPoints, equals(10));
    });
  });
}
