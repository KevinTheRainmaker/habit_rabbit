class MissionCheckUseCase {
  final int totalCheckins;
  final int habitCount;
  final int bestStreak;

  const MissionCheckUseCase({
    required this.totalCheckins,
    required this.habitCount,
    required this.bestStreak,
  });

  List<String> get completableMissionIds {
    final ids = <String>[];
    if (totalCheckins >= 1) ids.add('mission-first-checkin');
    if (bestStreak >= 7) ids.add('mission-7day-streak');
    if (bestStreak >= 30) ids.add('mission-30day-streak');
    if (habitCount >= 3) ids.add('mission-3habits');
    if (totalCheckins >= 100) ids.add('mission-100-checkins');
    return ids;
  }
}
