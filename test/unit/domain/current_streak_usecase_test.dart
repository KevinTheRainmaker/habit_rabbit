import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/current_streak_usecase.dart';

void main() {
  group('CurrentStreakUseCase', () {
    test('빈 체크인 목록이면 0 반환', () {
      final useCase = CurrentStreakUseCase(checkins: [], today: DateTime(2026, 3, 7));
      expect(useCase.currentStreak, 0);
    });

    test('오늘 체크인이 있으면 1 이상 반환', () {
      final today = DateTime(2026, 3, 7);
      final useCase = CurrentStreakUseCase(
        checkins: [today],
        today: today,
      );
      expect(useCase.currentStreak, 1);
    });

    test('오늘 체크인 없고 어제도 없으면 0 반환', () {
      final today = DateTime(2026, 3, 7);
      final useCase = CurrentStreakUseCase(
        checkins: [DateTime(2026, 3, 5)],
        today: today,
      );
      expect(useCase.currentStreak, 0);
    });

    test('어제부터 오늘까지 연속이면 2 반환', () {
      final today = DateTime(2026, 3, 7);
      final useCase = CurrentStreakUseCase(
        checkins: [
          DateTime(2026, 3, 6),
          DateTime(2026, 3, 7),
        ],
        today: today,
      );
      expect(useCase.currentStreak, 2);
    });

    test('오늘 체크인 없고 어제까지 연속이면 어제 스트릭 반환', () {
      final today = DateTime(2026, 3, 7);
      final useCase = CurrentStreakUseCase(
        checkins: [
          DateTime(2026, 3, 5),
          DateTime(2026, 3, 6),
        ],
        today: today,
      );
      expect(useCase.currentStreak, 2);
    });
  });
}
