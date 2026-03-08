import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/mission_check_usecase.dart';

void main() {
  group('MissionCheckUseCase', () {
    test('체크인 0개면 빈 목록', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 0,
        habitCount: 0,
        bestStreak: 0,
      );
      expect(useCase.completableMissionIds, isEmpty);
    });

    test('첫 체크인 시 mission-first-checkin 포함', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 1,
        habitCount: 1,
        bestStreak: 1,
      );
      expect(useCase.completableMissionIds, contains('mission-first-checkin'));
    });

    test('7일 연속 스트릭이면 mission-7day-streak 포함', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 7,
        habitCount: 1,
        bestStreak: 7,
      );
      expect(useCase.completableMissionIds, contains('mission-7day-streak'));
    });

    test('30일 연속 스트릭이면 mission-30day-streak 포함', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 30,
        habitCount: 1,
        bestStreak: 30,
      );
      expect(useCase.completableMissionIds, contains('mission-30day-streak'));
    });

    test('습관 3개 이상이면 mission-3habits 포함', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 0,
        habitCount: 3,
        bestStreak: 0,
      );
      expect(useCase.completableMissionIds, contains('mission-3habits'));
    });

    test('체크인 100개 이상이면 mission-100-checkins 포함', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 100,
        habitCount: 1,
        bestStreak: 1,
      );
      expect(useCase.completableMissionIds, contains('mission-100-checkins'));
    });

    test('조건 미충족 미션은 포함되지 않음', () {
      final useCase = MissionCheckUseCase(
        totalCheckins: 1,
        habitCount: 1,
        bestStreak: 1,
      );
      expect(useCase.completableMissionIds, isNot(contains('mission-7day-streak')));
    });
  });
}
