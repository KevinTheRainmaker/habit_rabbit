import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_shop_repository.dart';

void main() {
  group('equip/unequip', () {
    test('아이템 장착 후 장착 목록에 포함', () async {
      final repo = InMemoryShopRepository();
      // 먼저 구매
      await repo.purchaseItem(itemId: 'hat-1', currentPoints: 9999);

      await repo.equipItem(itemId: 'hat-1');

      final equipped = await repo.getEquippedItems();
      expect(equipped.any((i) => i.id == 'hat-1'), isTrue);
    });

    test('아이템 해제 후 장착 목록에서 제거', () async {
      final repo = InMemoryShopRepository();
      await repo.purchaseItem(itemId: 'hat-1', currentPoints: 9999);
      await repo.equipItem(itemId: 'hat-1');

      await repo.unequipItem(itemId: 'hat-1');

      final equipped = await repo.getEquippedItems();
      expect(equipped.any((i) => i.id == 'hat-1'), isFalse);
    });

    test('소유하지 않은 아이템은 장착 불가', () async {
      final repo = InMemoryShopRepository();

      expect(
        () => repo.equipItem(itemId: 'hat-1'),
        throwsException,
      );
    });
  });
}
