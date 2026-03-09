import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/providers/sync_provider.dart';

void main() {
  group('lastSyncedAtProvider', () {
    test('초기값은 null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(lastSyncedAtProvider);
      expect(value, isNull);
    });

    test('동기화 시간 업데이트', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime(2026, 3, 10, 12, 0);
      container.read(lastSyncedAtProvider.notifier).update(now);

      expect(container.read(lastSyncedAtProvider), now);
    });
  });
}
