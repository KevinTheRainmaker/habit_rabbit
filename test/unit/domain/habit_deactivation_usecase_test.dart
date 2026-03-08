import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/usecases/habit_deactivation_usecase.dart';

void main() {
  Habit makeHabit(String id) => Habit(
        id: id,
        userId: 'uid-1',
        name: '습관 $id',
        createdAt: DateTime(2026, 3, 1),
        isActive: true,
      );

  group('HabitDeactivationUseCase', () {
    test('3개 이하면 비활성화 없음', () {
      final habits = [makeHabit('h-1'), makeHabit('h-2'), makeHabit('h-3')];
      final useCase = HabitDeactivationUseCase(
        habits: habits,
        isPremium: false,
        freeLimit: 3,
      );
      expect(useCase.habitsToDeactivate, isEmpty);
    });

    test('무료 한도(3개) 초과 시 초과분 반환', () {
      final habits = [
        makeHabit('h-1'),
        makeHabit('h-2'),
        makeHabit('h-3'),
        makeHabit('h-4'),
        makeHabit('h-5'),
      ];
      final useCase = HabitDeactivationUseCase(
        habits: habits,
        isPremium: false,
        freeLimit: 3,
      );
      expect(useCase.habitsToDeactivate.length, 2);
    });

    test('프리미엄이면 초과 습관 없음', () {
      final habits = List.generate(5, (i) => makeHabit('h-$i'));
      final useCase = HabitDeactivationUseCase(
        habits: habits,
        isPremium: true,
        freeLimit: 3,
      );
      expect(useCase.habitsToDeactivate, isEmpty);
    });

    test('비활성화 대상은 한도 초과분 (나중에 추가된 것들)', () {
      final habits = [
        makeHabit('h-1'),
        makeHabit('h-2'),
        makeHabit('h-3'),
        makeHabit('h-4'),
      ];
      final useCase = HabitDeactivationUseCase(
        habits: habits,
        isPremium: false,
        freeLimit: 3,
      );
      expect(useCase.habitsToDeactivate.map((h) => h.id), contains('h-4'));
    });
  });
}
