import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/providers/carrot_points_provider.dart';

void main() {
  group('CarrotPointsNotifier', () {
    test('초기 포인트는 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final points = container.read(carrotPointsProvider);

      expect(points, equals(0));
    });

    test('add(10): 포인트 10 증가', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(carrotPointsProvider.notifier).add(10);

      expect(container.read(carrotPointsProvider), equals(10));
    });

    test('add 여러 번: 누적 적립', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(carrotPointsProvider.notifier).add(10);
      container.read(carrotPointsProvider.notifier).add(15);

      expect(container.read(carrotPointsProvider), equals(25));
    });

    test('reset: 포인트 0으로 초기화', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(carrotPointsProvider.notifier).add(10);
      container.read(carrotPointsProvider.notifier).reset();

      expect(container.read(carrotPointsProvider), equals(0));
    });
  });
}
