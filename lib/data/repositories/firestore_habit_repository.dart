import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class FirestoreHabitRepository implements HabitRepository {
  final FirebaseFirestore _db;

  FirestoreHabitRepository([FirebaseFirestore? db])
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference _habitsCol(String userId) =>
      _db.collection('users').doc(userId).collection('habits');

  CollectionReference _checkinsCol(String userId) =>
      _db.collection('users').doc(userId).collection('checkins');

  String _checkinId(String habitId, String userId, DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${habitId}_${userId}_$dateStr';
  }

  Habit _habitFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: data['id'] as String,
      userId: data['userId'] as String,
      name: data['name'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
      isActive: data['isActive'] as bool,
      targetDays: (data['targetDays'] as List?)?.cast<int>() ?? [0, 1, 2, 3, 4, 5, 6],
      icon: data['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> _habitToMap(Habit habit) => {
        'id': habit.id,
        'userId': habit.userId,
        'name': habit.name,
        'createdAt': habit.createdAt.toIso8601String(),
        'isActive': habit.isActive,
        'targetDays': habit.targetDays,
        'icon': habit.icon,
      };

  Checkin _checkinFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Checkin(
      id: data['id'] as String,
      habitId: data['habitId'] as String,
      userId: data['userId'] as String,
      date: DateTime.parse(data['date'] as String),
      streakDay: data['streakDay'] as int,
    );
  }

  @override
  Future<List<Habit>> getHabits({required String userId}) async {
    final snapshot = await _habitsCol(userId).get();
    return snapshot.docs.map(_habitFromDoc).toList();
  }

  @override
  Future<Habit> addHabit(Habit habit) async {
    await _habitsCol(habit.userId).doc(habit.id).set(_habitToMap(habit));
    return habit;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _habitsCol(habit.userId).doc(habit.id).set(_habitToMap(habit));
  }

  @override
  Future<void> deleteHabit({required String habitId, required String userId}) async {
    await _habitsCol(userId).doc(habitId).delete();
    final checkins = await _checkinsCol(userId)
        .where('habitId', isEqualTo: habitId)
        .get();
    for (final doc in checkins.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final id = _checkinId(habitId, userId, date);
    final docRef = _checkinsCol(userId).doc(id);
    final existing = await docRef.get();
    if (existing.exists) {
      throw Exception('이미 오늘 체크인했습니다: $id');
    }

    final streakSnapshot = await _checkinsCol(userId)
        .where('habitId', isEqualTo: habitId)
        .where('userId', isEqualTo: userId)
        .get();
    final streakDay = streakSnapshot.docs.length;

    final checkin = Checkin(
      id: id,
      habitId: habitId,
      userId: userId,
      date: date,
      streakDay: streakDay,
    );

    await docRef.set({
      'id': checkin.id,
      'habitId': checkin.habitId,
      'userId': checkin.userId,
      'date': checkin.date.toIso8601String(),
      'streakDay': checkin.streakDay,
    });

    return checkin;
  }

  @override
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  }) async {
    final snapshot = await _checkinsCol(userId)
        .where('habitId', isEqualTo: habitId)
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map(_checkinFromDoc).toList();
  }
}
