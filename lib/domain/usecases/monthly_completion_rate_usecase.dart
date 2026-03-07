import 'package:habit_rabbit/domain/entities/checkin.dart';

class MonthlyCompletionRateUseCase {
  double call({required List<Checkin> checkins, required DateTime today}) {
    final daysElapsed = today.day; // 1일~오늘까지 일수
    if (daysElapsed == 0) return 0.0;

    final thisMonthCheckins = checkins.where((c) =>
        c.date.year == today.year && c.date.month == today.month).length;

    return thisMonthCheckins / daysElapsed;
  }
}
