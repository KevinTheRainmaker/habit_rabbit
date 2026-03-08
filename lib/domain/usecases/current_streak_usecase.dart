class CurrentStreakUseCase {
  final List<DateTime> checkins;
  final DateTime today;

  const CurrentStreakUseCase({required this.checkins, required this.today});

  int get currentStreak {
    if (checkins.isEmpty) return 0;

    final todayDate = DateTime(today.year, today.month, today.day);

    final dates = checkins
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    // start from today or yesterday
    final latestDate = dates.last;
    final diffFromToday = todayDate.difference(latestDate).inDays;
    if (diffFromToday > 1) return 0; // streak is broken

    int streak = 1;
    for (int i = dates.length - 2; i >= 0; i--) {
      final diff = dates[i + 1].difference(dates[i]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
