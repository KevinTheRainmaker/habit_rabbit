import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/streak_break_check_usecase.dart';

void main() {
  group('StreakBreakCheckUseCase', () {
    test('오늘 미체크 + 어제 체크 있으면 스트릭 유지 중', () {
      final today = DateTime(2026, 3, 7);
      final yesterday = today.subtract(const Duration(days: 1));
      final usecase = StreakBreakCheckUseCase(
        checkins: [yesterday],
        today: today,
      );
      expect(usecase.isStreakBroken, isFalse);
    });

    test('오늘 미체크 + 어제 체크 없으면 스트릭 끊김', () {
      final today = DateTime(2026, 3, 7);
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final usecase = StreakBreakCheckUseCase(
        checkins: [twoDaysAgo],
        today: today,
      );
      expect(usecase.isStreakBroken, isTrue);
    });

    test('체크인 없으면 끊김 아님', () {
      final today = DateTime(2026, 3, 7);
      final usecase = StreakBreakCheckUseCase(
        checkins: [],
        today: today,
      );
      expect(usecase.isStreakBroken, isFalse);
    });
  });
}
