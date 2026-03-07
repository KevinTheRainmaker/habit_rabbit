import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_shop_repository.dart';
import 'package:habit_rabbit/domain/repositories/shop_repository.dart';

void main() {
  group('InMemoryShopRepository', () {
    test('ShopRepository를 구현한다', () {
      final repo = InMemoryShopRepository();
      expect(repo, isA<ShopRepository>());
    });

    test('기본 아이템 목록 반환', () async {
      final repo = InMemoryShopRepository();
      final items = await repo.getItems();
      expect(items.length, greaterThanOrEqualTo(3));
    });

    test('아이템 구매 시 소유 목록에 추가', () async {
      final repo = InMemoryShopRepository();
      final items = await repo.getItems();
      final item = items.first;

      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);

      final owned = await repo.getOwnedItems();
      expect(owned.any((i) => i.id == item.id), isTrue);
    });

    test('잔액 부족 시 예외 발생', () async {
      final repo = InMemoryShopRepository();
      final items = await repo.getItems();
      final item = items.first;

      expect(
        () => repo.purchaseItem(itemId: item.id, currentPoints: 0),
        throwsException,
      );
    });

    test('이미 소유한 아이템은 재구매 불가', () async {
      final repo = InMemoryShopRepository();
      final items = await repo.getItems();
      final item = items.first;

      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);

      expect(
        () => repo.purchaseItem(itemId: item.id, currentPoints: 9999),
        throwsException,
      );
    });
  });
}
