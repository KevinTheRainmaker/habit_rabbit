import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/usecases/today_progress_usecase.dart';

void main() {
  final today = DateTime(2026, 3, 7); // 금요일

  Habit makeHabit(String id) => Habit(
        id: id,
        userId: 'u-1',
        name: 'Habit $id',
        createdAt: today,
        isActive: true,
      );

  Checkin makeCheckin(String habitId) => Checkin(
        id: 'c-$habitId',
        habitId: habitId,
        userId: 'u-1',
        date: today,
        streakDay: 0,
      );

  group('TodayProgressUseCase', () {
    test('오늘 습관 2개 중 1개 완료 → completed=1, total=2', () {
      final habits = [makeHabit('h-1'), makeHabit('h-2')];
      final checkins = [makeCheckin('h-1')];
      final usecase = TodayProgressUseCase(
        habits: habits,
        checkins: checkins,
        today: today,
      );
      expect(usecase.completed, equals(1));
      expect(usecase.total, equals(2));
    });

    test('완료 없으면 completed=0', () {
      final habits = [makeHabit('h-1'), makeHabit('h-2')];
      final usecase = TodayProgressUseCase(
        habits: habits,
        checkins: [],
        today: today,
      );
      expect(usecase.completed, equals(0));
      expect(usecase.total, equals(2));
    });

    test('오늘 습관 없으면 0/0', () {
      final usecase = TodayProgressUseCase(
        habits: [],
        checkins: [],
        today: today,
      );
      expect(usecase.completed, equals(0));
      expect(usecase.total, equals(0));
    });

    test('오늘이 아닌 날짜 체크인은 카운트 안 됨', () {
      final yesterday = today.subtract(const Duration(days: 1));
      final habits = [makeHabit('h-1')];
      final checkins = [
        Checkin(
          id: 'c-1',
          habitId: 'h-1',
          userId: 'u-1',
          date: yesterday,
          streakDay: 0,
        ),
      ];
      final usecase = TodayProgressUseCase(
        habits: habits,
        checkins: checkins,
        today: today,
      );
      expect(usecase.completed, equals(0));
    });
  });
}
