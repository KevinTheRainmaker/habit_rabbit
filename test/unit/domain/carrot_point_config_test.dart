import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

void main() {
  group('CarrotPointConfig', () {
    test('기본값: 기본 10 포인트, 7일 +5, 30일 +10, 100일 +15', () {
      const config = CarrotPointConfig();
      expect(config.basePoints, 10);
      expect(config.sevenDayBonus, 5);
      expect(config.thirtyDayBonus, 10);
      expect(config.hundredDayBonus, 15);
    });

    test('streakDay 0: 기본 포인트만 반환', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(0), 10);
    });

    test('streakDay 6 (7일차): 기본 + 7일 보너스', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(6), 15);
    });

    test('streakDay 29 (30일차): 기본 + 30일 보너스', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(29), 20);
    });

    test('streakDay 99 (100일차): 기본 + 100일 보너스', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(99), 25);
    });

    test('커스텀 설정으로 포인트 계산', () {
      const config = CarrotPointConfig(basePoints: 20, sevenDayBonus: 10);
      expect(config.computePoints(0), 20);
      expect(config.computePoints(6), 30);
    });

    test('defaults 상수는 기본 CarrotPointConfig와 동일', () {
      expect(CarrotPointConfig.defaults, const CarrotPointConfig());
    });
  });
}
