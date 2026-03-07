import 'package:habit_rabbit/domain/entities/shop_item.dart';

abstract class ShopRepository {
  Future<List<ShopItem>> getItems();
  Future<List<ShopItem>> getOwnedItems();
  Future<List<ShopItem>> getEquippedItems();
  Future<void> purchaseItem({
    required String itemId,
    required int currentPoints,
  });
  Future<void> equipItem({required String itemId});
  Future<void> unequipItem({required String itemId});
}
