import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';

void main() {
  group('Checkin 당근 포인트', () {
    test('스트릭 0일: 기본 10포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );

      expect(checkin.carrotPoints, equals(10));
    });

    test('스트릭 6일(7일 달성): 보너스 5포인트 추가 = 15포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 6,
      );

      expect(checkin.carrotPoints, equals(15));
    });

    test('스트릭 29일(30일 달성): 보너스 10포인트 추가 = 20포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 29,
      );

      expect(checkin.carrotPoints, equals(20));
    });

    test('스트릭 99일(100일 달성): 보너스 15포인트 추가 = 25포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 99,
      );

      expect(checkin.carrotPoints, equals(25));
    });

    test('(habit-1, uid-1, 2026-03-07) 동일 조합은 동일한 체크인', () {
      final c1 = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );
      final c2 = Checkin(
        id: 'c-2',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 5,
      );

      expect(c1, equals(c2));
    });
  });
}
