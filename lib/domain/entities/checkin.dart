import 'package:equatable/equatable.dart';

class Checkin extends Equatable {
  final String id;
  final String habitId;
  final String userId;
  final DateTime date;
  final int streakDay;

  const Checkin({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.streakDay,
  });

  /// 당근 포인트: 기본 10 + 스트릭 보너스
  /// 7일 달성 (streakDay == 6): +5
  /// 30일 달성 (streakDay == 29): +10
  int get carrotPoints {
    int points = 10;
    if (streakDay == 99) {
      points += 15;
    } else if (streakDay == 29) {
      points += 10;
    } else if (streakDay == 6) {
      points += 5;
    }
    return points;
  }

  /// 멱등성 키: (habitId, userId, date)로 중복 체크인 방지
  String get idempotencyKey =>
      '${habitId}_${userId}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  List<Object> get props => [habitId, userId, date];
}
