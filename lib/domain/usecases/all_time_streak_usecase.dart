import 'package:habit_rabbit/domain/entities/checkin.dart';

class AllTimeStreakUseCase {
  int call({required List<Checkin> checkins}) {
    if (checkins.isEmpty) return 0;

    final sorted = [...checkins]
      ..sort((a, b) => a.date.compareTo(b.date));

    int maxStreak = 1;
    int current = 1;

    for (int i = 1; i < sorted.length; i++) {
      final prev = DateTime(
        sorted[i - 1].date.year,
        sorted[i - 1].date.month,
        sorted[i - 1].date.day,
      );
      final curr = DateTime(
        sorted[i].date.year,
        sorted[i].date.month,
        sorted[i].date.day,
      );
      final diff = curr.difference(prev).inDays;

      if (diff == 1) {
        current++;
        if (current > maxStreak) maxStreak = current;
      } else {
        current = 1;
      }
    }

    return maxStreak;
  }
}
