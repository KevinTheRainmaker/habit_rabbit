import 'package:habit_rabbit/domain/entities/habit.dart';

class HabitDeactivationUseCase {
  final List<Habit> habits;
  final bool isPremium;
  final int freeLimit;

  const HabitDeactivationUseCase({
    required this.habits,
    required this.isPremium,
    this.freeLimit = 3,
  });

  List<Habit> get habitsToDeactivate {
    if (isPremium || habits.length <= freeLimit) return [];
    return habits.sublist(freeLimit);
  }
}
