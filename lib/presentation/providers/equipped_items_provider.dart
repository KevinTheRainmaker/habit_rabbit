import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';

final equippedItemsProvider = FutureProvider<List<ShopItem>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.getEquippedItems();
});

class EquipNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> equip({required String itemId}) async {
    final repo = ref.read(shopRepositoryProvider);
    await repo.equipItem(itemId: itemId);
    ref.invalidate(equippedItemsProvider);
  }

  Future<void> unequip({required String itemId}) async {
    final repo = ref.read(shopRepositoryProvider);
    await repo.unequipItem(itemId: itemId);
    ref.invalidate(equippedItemsProvider);
  }
}

final equipNotifierProvider = NotifierProvider<EquipNotifier, void>(
  EquipNotifier.new,
);
