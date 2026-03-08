class FailurePatternUseCase {
  final List<DateTime> checkins;
  final DateTime today;

  const FailurePatternUseCase({required this.checkins, required this.today});

  /// 14일 이상의 체크인 데이터가 있어야 분석 준비 완료
  bool get isReady => checkins.length >= 14;

  /// 가장 체크인이 적은 요일 (0=월, 1=화, ..., 6=일). 데이터 부족 시 null.
  int? get worstDay {
    if (checkins.isEmpty) return null;

    // 최근 14일 날짜 수집
    final todayDate = DateTime(today.year, today.month, today.day);
    final last14Days = List.generate(
      14,
      (i) => todayDate.subtract(Duration(days: i)),
    );

    // 요일별 체크인 수 집계 (0=월~6=일, DateTime.weekday: 1=월~7=일)
    final counts = List.filled(7, 0);
    for (final date in last14Days) {
      final dayIndex = date.weekday - 1; // 0=월~6=일
      final hasCheckin = checkins.any((c) =>
          c.year == date.year && c.month == date.month && c.day == date.day);
      if (hasCheckin) counts[dayIndex]++;
    }

    // 가장 체크인이 적은 요일 반환
    int worstIndex = 0;
    for (int i = 1; i < 7; i++) {
      if (counts[i] < counts[worstIndex]) {
        worstIndex = i;
      }
    }

    return worstIndex;
  }

  static const _dayNames = ['월', '화', '수', '목', '금', '토', '일'];

  String? get worstDayName {
    final day = worstDay;
    if (day == null) return null;
    return _dayNames[day];
  }
}
