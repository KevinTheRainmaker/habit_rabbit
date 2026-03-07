import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits({required String userId});
  Future<Habit> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit({required String habitId, required String userId});
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  });
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  });
}
