import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class GetCheckinsUseCase {
  final HabitRepository _repository;

  GetCheckinsUseCase(this._repository);

  Future<List<Checkin>> call({
    required String habitId,
    required String userId,
  }) {
    return _repository.getCheckins(habitId: habitId, userId: userId);
  }

  /// 오늘 기준으로 연속 체크인 일수 계산
  Future<int> currentStreak({
    required String habitId,
    required String userId,
    required DateTime today,
  }) async {
    final checkins = await _repository.getCheckins(habitId: habitId, userId: userId);
    if (checkins.isEmpty) return 0;

    // 날짜 기준 내림차순 정렬
    final sorted = [...checkins]..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime expected = DateTime(today.year, today.month, today.day);

    for (final checkin in sorted) {
      final checkinDate = DateTime(checkin.date.year, checkin.date.month, checkin.date.day);
      if (checkinDate == expected) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
