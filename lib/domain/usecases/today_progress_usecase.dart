import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

class TodayProgressUseCase {
  final List<Habit> habits;
  final List<Checkin> checkins;
  final DateTime today;

  const TodayProgressUseCase({
    required this.habits,
    required this.checkins,
    required this.today,
  });

  int get total => habits.length;

  int get completed {
    return habits.where((habit) {
      return checkins.any((c) =>
          c.habitId == habit.id &&
          c.date.year == today.year &&
          c.date.month == today.month &&
          c.date.day == today.day);
    }).length;
  }
}
