class StreakMilestoneUseCase {
  final int streak;

  const StreakMilestoneUseCase({required this.streak});

  String? get message {
    switch (streak) {
      case 5:
        return '🔥 5일 연속 달성! 불꽃이 타오르고 있어요!';
      case 10:
        return '🎉 10일 연속 달성! 습관이 자리를 잡고 있어요!';
      case 30:
        return '🏆 30일 연속 달성! 진정한 습관 마스터예요!';
      case 100:
        return '🌟 100일 연속 달성! 전설이 탄생했어요!';
      default:
        return null;
    }
  }
}
