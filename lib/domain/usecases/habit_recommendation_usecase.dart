class HabitRecommendationUseCase {
  final List<String> answers;

  const HabitRecommendationUseCase({required this.answers});

  List<String> get recommendations {
    final joined = answers.join(' ');

    if (joined.contains('아침')) {
      return ['매일 물 한 잔 마시기', '10분 스트레칭', '5분 명상'];
    }

    if (joined.contains('취침') || joined.contains('마음')) {
      return ['감사 일기 쓰기', '하루 10분 독서', '10분 명상'];
    }

    if (joined.contains('생산성')) {
      return ['하루 10분 독서', '할 일 목록 작성', '30분 집중 공부'];
    }

    if (joined.contains('건강')) {
      return ['30분 걷기', '10분 스트레칭', '매일 물 8잔 마시기'];
    }

    // 기본 추천
    return ['매일 물 8잔 마시기', '10분 스트레칭', '하루 10분 독서'];
  }
}
