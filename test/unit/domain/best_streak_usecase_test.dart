import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/best_streak_usecase.dart';

void main() {
  group('BestStreakUseCase', () {
    test('빈 체크인 목록이면 0 반환', () {
      final useCase = BestStreakUseCase(checkins: []);
      expect(useCase.bestStreak, 0);
    });

    test('연속 3일 체크인이면 3 반환', () {
      final useCase = BestStreakUseCase(
        checkins: [
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 2),
          DateTime(2026, 3, 3),
        ],
      );
      expect(useCase.bestStreak, 3);
    });

    test('중간에 끊기면 최장 연속 구간만 반환', () {
      final useCase = BestStreakUseCase(
        checkins: [
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 2),
          // 3일 건너뜀
          DateTime(2026, 3, 4),
          DateTime(2026, 3, 5),
          DateTime(2026, 3, 6),
          DateTime(2026, 3, 7),
        ],
      );
      expect(useCase.bestStreak, 4);
    });

    test('하루만 있으면 1 반환', () {
      final useCase = BestStreakUseCase(
        checkins: [DateTime(2026, 3, 7)],
      );
      expect(useCase.bestStreak, 1);
    });
  });
}
