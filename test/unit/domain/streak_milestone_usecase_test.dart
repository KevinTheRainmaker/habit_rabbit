import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/streak_milestone_usecase.dart';

void main() {
  group('StreakMilestoneUseCase', () {
    test('5일 달성 → 마일스톤 메시지 반환', () {
      final usecase = StreakMilestoneUseCase(streak: 5);
      expect(usecase.message, isNotNull);
    });

    test('10일 달성 → 마일스톤 메시지 반환', () {
      final usecase = StreakMilestoneUseCase(streak: 10);
      expect(usecase.message, isNotNull);
    });

    test('30일 달성 → 마일스톤 메시지 반환', () {
      final usecase = StreakMilestoneUseCase(streak: 30);
      expect(usecase.message, isNotNull);
    });

    test('100일 달성 → 마일스톤 메시지 반환', () {
      final usecase = StreakMilestoneUseCase(streak: 100);
      expect(usecase.message, isNotNull);
    });

    test('마일스톤 아닌 날 → null 반환', () {
      final usecase = StreakMilestoneUseCase(streak: 3);
      expect(usecase.message, isNull);
    });

    test('1일은 마일스톤 아님', () {
      final usecase = StreakMilestoneUseCase(streak: 1);
      expect(usecase.message, isNull);
    });
  });
}
