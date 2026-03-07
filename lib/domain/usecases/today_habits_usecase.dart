import 'package:habit_rabbit/domain/entities/habit.dart';

class TodayHabitsUseCase {
  /// [today]의 요일(0=월~6=일)에 해당하는 습관만 반환.
  /// Dart weekday: 1=월, 7=일 → targetDays index = weekday - 1 (일요일은 7-1=6)
  List<Habit> call({required List<Habit> habits, required DateTime today}) {
    final todayIndex = today.weekday == 7 ? 6 : today.weekday - 1;
    return habits.where((h) => h.targetDays.contains(todayIndex)).toList();
  }
}
