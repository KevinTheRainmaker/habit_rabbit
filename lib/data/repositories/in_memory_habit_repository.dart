import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class InMemoryHabitRepository implements HabitRepository {
  final List<Habit> _habits = [];
  final List<Checkin> _checkins = [];

  @override
  Future<List<Habit>> getHabits({required String userId}) async {
    return _habits.where((h) => h.userId == userId).toList();
  }

  @override
  Future<Habit> addHabit(Habit habit) async {
    _habits.add(habit);
    return habit;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) _habits[index] = habit;
  }

  @override
  Future<void> deleteHabit({required String habitId, required String userId}) async {
    _habits.removeWhere((h) => h.id == habitId && h.userId == userId);
  }

  @override
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final key = '${habitId}_${userId}_${date.year}-${date.month}-${date.day}';
    final alreadyCheckedIn = _checkins.any(
      (c) => c.habitId == habitId && c.userId == userId &&
          c.date.year == date.year && c.date.month == date.month && c.date.day == date.day,
    );
    if (alreadyCheckedIn) throw Exception('이미 오늘 체크인했습니다: $key');

    final streakDay = _checkins.where((c) => c.habitId == habitId && c.userId == userId).length;
    final checkin = Checkin(
      id: key,
      habitId: habitId,
      userId: userId,
      date: date,
      streakDay: streakDay,
    );
    _checkins.add(checkin);
    return checkin;
  }

  @override
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  }) async {
    return _checkins.where((c) => c.habitId == habitId && c.userId == userId).toList();
  }
}
