import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/datasources/default_remote_config_client.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

void main() {
  group('DefaultRemoteConfigClient', () {
    test('fetchCarrotConfig는 CarrotPointConfig.defaults 반환', () async {
      final client = DefaultRemoteConfigClient();
      final config = await client.fetchCarrotConfig();
      expect(config, CarrotPointConfig.defaults);
    });

    test('반환값은 기본 포인트 설정', () async {
      final client = DefaultRemoteConfigClient();
      final config = await client.fetchCarrotConfig();
      expect(config.basePoints, 10);
      expect(config.sevenDayBonus, 5);
    });
  });
}
