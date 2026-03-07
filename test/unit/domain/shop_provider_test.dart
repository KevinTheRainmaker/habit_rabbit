import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';

void main() {
  group('shopProvider', () {
    test('shopItemsProvider는 아이템 목록을 반환한다', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final items = await container.read(shopItemsProvider.future);
      expect(items, isA<List<ShopItem>>());
      expect(items.length, greaterThanOrEqualTo(3));
    });

    test('purchaseItem 후 아이템이 owned 상태로 변경', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 먼저 아이템 목록 로드
      final items = await container.read(shopItemsProvider.future);
      final firstItem = items.first;

      // 충분한 포인트로 구매
      await container
          .read(shopNotifierProvider.notifier)
          .purchaseItem(itemId: firstItem.id, currentPoints: 9999);

      // 구매 후 목록 재조회
      final updatedItems = await container.read(shopItemsProvider.future);
      final purchased = updatedItems.firstWhere((i) => i.id == firstItem.id);
      expect(purchased.isOwned, isTrue);
    });
  });
}
