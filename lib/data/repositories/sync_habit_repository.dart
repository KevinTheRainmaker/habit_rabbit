import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class SyncHabitRepository implements HabitRepository {
  final HabitRepository _local;
  final HabitRepository _remote;

  SyncHabitRepository({
    required HabitRepository local,
    required HabitRepository remote,
  })  : _local = local,
        _remote = remote;

  /// 로그인 시 리모트에서 로컬로 동기화 (오프라인 무시)
  Future<void> syncFromRemote({required String userId}) async {
    try {
      final remoteHabits = await _remote.getHabits(userId: userId);
      for (final habit in remoteHabits) {
        await _local.addHabit(habit);
      }
    } catch (_) {
      // 오프라인 또는 리모트 오류 → 로컬 데이터 사용
    }
  }

  @override
  Future<List<Habit>> getHabits({required String userId}) =>
      _local.getHabits(userId: userId);

  @override
  Future<Habit> addHabit(Habit habit) async {
    final result = await _local.addHabit(habit);
    Future.sync(() => _remote.addHabit(habit)).ignore();
    return result;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _local.updateHabit(habit);
    Future.sync(() => _remote.updateHabit(habit)).ignore();
  }

  @override
  Future<void> deleteHabit({
    required String habitId,
    required String userId,
  }) async {
    await _local.deleteHabit(habitId: habitId, userId: userId);
    Future.sync(
      () => _remote.deleteHabit(habitId: habitId, userId: userId),
    ).ignore();
  }

  @override
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final result = await _local.checkIn(
      habitId: habitId,
      userId: userId,
      date: date,
    );
    Future.sync(
      () => _remote.checkIn(habitId: habitId, userId: userId, date: date),
    ).ignore();
    return result;
  }

  @override
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  }) =>
      _local.getCheckins(habitId: habitId, userId: userId);
}
