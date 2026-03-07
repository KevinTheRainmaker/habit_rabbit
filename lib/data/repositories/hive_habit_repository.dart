import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class HiveHabitRepository implements HabitRepository {
  final Box _box;

  HiveHabitRepository(this._box);

  String _habitKey(String habitId) => 'habit_$habitId';

  String _checkinKey(String habitId, String userId, DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'checkin_${habitId}_${userId}_$dateStr';
  }

  Habit _habitFromMap(Map map) => Habit(
        id: map['id'] as String,
        userId: map['userId'] as String,
        name: map['name'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        isActive: map['isActive'] as bool,
      );

  Map<String, dynamic> _habitToMap(Habit habit) => {
        'type': 'habit',
        'id': habit.id,
        'userId': habit.userId,
        'name': habit.name,
        'createdAt': habit.createdAt.toIso8601String(),
        'isActive': habit.isActive,
      };

  Checkin _checkinFromMap(Map map) => Checkin(
        id: map['id'] as String,
        habitId: map['habitId'] as String,
        userId: map['userId'] as String,
        date: DateTime.parse(map['date'] as String),
        streakDay: map['streakDay'] as int,
      );

  Map<String, dynamic> _checkinToMap(Checkin checkin) => {
        'type': 'checkin',
        'id': checkin.id,
        'habitId': checkin.habitId,
        'userId': checkin.userId,
        'date': checkin.date.toIso8601String(),
        'streakDay': checkin.streakDay,
      };

  @override
  Future<List<Habit>> getHabits({required String userId}) async {
    return _box.values
        .where((v) => v is Map && v['type'] == 'habit' && v['userId'] == userId)
        .map((v) => _habitFromMap(v as Map))
        .toList();
  }

  @override
  Future<Habit> addHabit(Habit habit) async {
    await _box.put(_habitKey(habit.id), _habitToMap(habit));
    return habit;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _box.put(_habitKey(habit.id), _habitToMap(habit));
  }

  @override
  Future<void> deleteHabit({required String habitId, required String userId}) async {
    await _box.delete(_habitKey(habitId));
    final checkinKeys = _box.keys
        .where((k) => k.toString().startsWith('checkin_${habitId}_$userId'))
        .toList();
    for (final key in checkinKeys) {
      await _box.delete(key);
    }
  }

  @override
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final key = _checkinKey(habitId, userId, date);
    if (_box.containsKey(key)) {
      throw Exception('이미 오늘 체크인했습니다: $key');
    }

    final streakDay = _box.values
        .where((v) => v is Map && v['type'] == 'checkin' &&
            v['habitId'] == habitId && v['userId'] == userId)
        .length;

    final checkin = Checkin(
      id: key,
      habitId: habitId,
      userId: userId,
      date: date,
      streakDay: streakDay,
    );
    await _box.put(key, _checkinToMap(checkin));
    return checkin;
  }

  @override
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  }) async {
    return _box.values
        .where((v) => v is Map && v['type'] == 'checkin' &&
            v['habitId'] == habitId && v['userId'] == userId)
        .map((v) => _checkinFromMap(v as Map))
        .toList();
  }
}
