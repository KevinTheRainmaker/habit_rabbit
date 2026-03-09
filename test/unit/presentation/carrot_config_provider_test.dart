import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/data/datasources/remote_config_client.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';
import 'package:habit_rabbit/presentation/providers/carrot_config_provider.dart';

class MockRemoteConfigClient extends Mock implements RemoteConfigClient {}

void main() {
  late MockRemoteConfigClient mockClient;

  setUp(() {
    mockClient = MockRemoteConfigClient();
  });

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [
          remoteConfigClientProvider.overrideWithValue(mockClient),
        ],
      );

  group('carrotConfigProvider', () {
    test('RemoteConfigClient로부터 CarrotPointConfig 로드', () async {
      when(() => mockClient.fetchCarrotConfig())
          .thenAnswer((_) async => const CarrotPointConfig(basePoints: 15));

      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(carrotConfigProvider.future);
      expect(config.basePoints, 15);
    });

    test('기본 클라이언트는 CarrotPointConfig.defaults 반환', () async {
      when(() => mockClient.fetchCarrotConfig())
          .thenAnswer((_) async => CarrotPointConfig.defaults);

      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(carrotConfigProvider.future);
      expect(config, CarrotPointConfig.defaults);
    });
  });
}
