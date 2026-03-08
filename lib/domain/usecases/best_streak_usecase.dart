class BestStreakUseCase {
  final List<DateTime> checkins;

  const BestStreakUseCase({required this.checkins});

  int get bestStreak {
    if (checkins.isEmpty) return 0;

    final sorted = checkins
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort();

    int best = 1;
    int current = 1;

    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > best) best = current;
      } else {
        current = 1;
      }
    }

    return best;
  }
}
