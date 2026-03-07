class CheckMissionUseCase {
  final int checkinCount;
  final int currentStreak;
  final int habitCount;

  const CheckMissionUseCase({
    required this.checkinCount,
    required this.currentStreak,
    required this.habitCount,
  });

  List<String> get completedMissionIds {
    final ids = <String>[];
    if (checkinCount >= 1) ids.add('mission-first-checkin');
    if (currentStreak >= 7) ids.add('mission-7day-streak');
    if (currentStreak >= 30) ids.add('mission-30day-streak');
    if (habitCount >= 3) ids.add('mission-3habits');
    if (checkinCount >= 100) ids.add('mission-100-checkins');
    return ids;
  }
}
