class WeeklyCompletionRateUseCase {
  final List<DateTime> checkins;
  final DateTime today;

  const WeeklyCompletionRateUseCase({
    required this.checkins,
    required this.today,
  });

  double get rate {
    int completed = 0;
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: i));
      if (checkins.any((d) =>
          d.year == day.year &&
          d.month == day.month &&
          d.day == day.day)) {
        completed++;
      }
    }
    return completed / 7;
  }
}
