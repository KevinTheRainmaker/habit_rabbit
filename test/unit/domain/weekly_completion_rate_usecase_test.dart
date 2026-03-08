import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/weekly_completion_rate_usecase.dart';

void main() {
  group('WeeklyCompletionRateUseCase', () {
    test('7일 모두 체크인 시 100%', () {
      final today = DateTime(2026, 3, 7);
      final checkins = List.generate(
        7,
        (i) => today.subtract(Duration(days: i)),
      );
      final usecase = WeeklyCompletionRateUseCase(
        checkins: checkins,
        today: today,
      );
      expect(usecase.rate, closeTo(1.0, 0.001));
    });

    test('7일 중 4일 체크인 시 약 57%', () {
      final today = DateTime(2026, 3, 7);
      final checkins = List.generate(
        4,
        (i) => today.subtract(Duration(days: i)),
      );
      final usecase = WeeklyCompletionRateUseCase(
        checkins: checkins,
        today: today,
      );
      expect(usecase.rate, closeTo(4 / 7, 0.001));
    });

    test('체크인 없으면 0%', () {
      final today = DateTime(2026, 3, 7);
      final usecase = WeeklyCompletionRateUseCase(
        checkins: [],
        today: today,
      );
      expect(usecase.rate, equals(0.0));
    });

    test('오늘 포함 최근 7일만 카운트', () {
      final today = DateTime(2026, 3, 7);
      // 8일 전 체크인은 카운트 안 됨
      final checkins = [
        today.subtract(const Duration(days: 8)),
        today.subtract(const Duration(days: 1)),
      ];
      final usecase = WeeklyCompletionRateUseCase(
        checkins: checkins,
        today: today,
      );
      expect(usecase.rate, closeTo(1 / 7, 0.001));
    });
  });
}
