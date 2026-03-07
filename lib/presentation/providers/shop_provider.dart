import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/repositories/in_memory_shop_repository.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/domain/repositories/shop_repository.dart';

final shopRepositoryProvider = Provider<ShopRepository>(
  (ref) => InMemoryShopRepository(),
);

final shopItemsProvider = FutureProvider<List<ShopItem>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.getItems();
});

class ShopNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> purchaseItem({
    required String itemId,
    required int currentPoints,
  }) async {
    final repo = ref.read(shopRepositoryProvider);
    await repo.purchaseItem(itemId: itemId, currentPoints: currentPoints);
    ref.invalidate(shopItemsProvider);
  }
}

final shopNotifierProvider = NotifierProvider<ShopNotifier, void>(
  ShopNotifier.new,
);
