import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/usecases/all_time_streak_usecase.dart';

void main() {
  group('AllTimeStreakUseCase', () {
    test('연속 체크인 최장 스트릭 계산', () {
      // 1~5일 연속(5일) + 7~9일 연속(3일) → 최장 5일
      final checkins = [
        Checkin(id: 'c-1', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 1), streakDay: 0),
        Checkin(id: 'c-2', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 2), streakDay: 1),
        Checkin(id: 'c-3', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 3), streakDay: 2),
        Checkin(id: 'c-4', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 4), streakDay: 3),
        Checkin(id: 'c-5', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 5), streakDay: 4),
        // 6일 건너뜀
        Checkin(id: 'c-6', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 7), streakDay: 0),
        Checkin(id: 'c-7', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 8), streakDay: 1),
        Checkin(id: 'c-8', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 9), streakDay: 2),
      ];

      final result = AllTimeStreakUseCase().call(checkins: checkins);

      expect(result, equals(5));
    });

    test('체크인 없으면 0', () {
      final result = AllTimeStreakUseCase().call(checkins: []);
      expect(result, equals(0));
    });

    test('체크인 1개면 1', () {
      final checkins = [
        Checkin(id: 'c-1', habitId: 'h', userId: 'u', date: DateTime(2026, 3, 1), streakDay: 0),
      ];
      final result = AllTimeStreakUseCase().call(checkins: checkins);
      expect(result, equals(1));
    });
  });
}
