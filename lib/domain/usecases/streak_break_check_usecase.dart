class StreakBreakCheckUseCase {
  final List<DateTime> checkins;
  final DateTime today;

  const StreakBreakCheckUseCase({
    required this.checkins,
    required this.today,
  });

  bool get isStreakBroken {
    if (checkins.isEmpty) return false;
    final yesterday = today.subtract(const Duration(days: 1));
    return !checkins.any((d) =>
        d.year == yesterday.year &&
        d.month == yesterday.month &&
        d.day == yesterday.day);
  }
}
