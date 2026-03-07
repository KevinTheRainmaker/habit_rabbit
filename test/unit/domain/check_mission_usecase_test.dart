import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/check_mission_usecase.dart';

void main() {
  group('CheckMissionUseCase', () {
    test('첫 습관 완료 미션 달성 조건: checkinCount >= 1', () {
      final usecase = CheckMissionUseCase(
        checkinCount: 1,
        currentStreak: 1,
        habitCount: 1,
      );
      expect(usecase.completedMissionIds, contains('mission-first-checkin'));
    });

    test('체크인 0회면 첫 습관 완료 미션 미달성', () {
      final usecase = CheckMissionUseCase(
        checkinCount: 0,
        currentStreak: 0,
        habitCount: 0,
      );
      expect(usecase.completedMissionIds, isNot(contains('mission-first-checkin')));
    });

    test('7일 스트릭 미션 달성 조건: currentStreak >= 7', () {
      final usecase = CheckMissionUseCase(
        checkinCount: 7,
        currentStreak: 7,
        habitCount: 1,
      );
      expect(usecase.completedMissionIds, contains('mission-7day-streak'));
    });

    test('30일 스트릭 미션 달성 조건: currentStreak >= 30', () {
      final usecase = CheckMissionUseCase(
        checkinCount: 30,
        currentStreak: 30,
        habitCount: 1,
      );
      expect(usecase.completedMissionIds, contains('mission-30day-streak'));
    });

    test('습관 3개 미션 달성 조건: habitCount >= 3', () {
      final usecase = CheckMissionUseCase(
        checkinCount: 0,
        currentStreak: 0,
        habitCount: 3,
      );
      expect(usecase.completedMissionIds, contains('mission-3habits'));
    });

    test('체크인 100회 미션 달성 조건: checkinCount >= 100', () {
      final usecase = CheckMissionUseCase(
        checkinCount: 100,
        currentStreak: 1,
        habitCount: 1,
      );
      expect(usecase.completedMissionIds, contains('mission-100-checkins'));
    });
  });
}
