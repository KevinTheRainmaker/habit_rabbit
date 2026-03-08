import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/domain/repositories/shop_repository.dart';

const _defaultItems = [
  ShopItem(id: 'hat-1', name: '토끼 모자', price: 100, category: '의상'),
  ShopItem(id: 'hat-2', name: '마법사 모자', price: 200, category: '의상'),
  ShopItem(id: 'bg-1', name: '꽃밭 배경', price: 150, category: '배경'),
  ShopItem(id: 'bg-2', name: '달밤 배경', price: 250, category: '배경'),
  ShopItem(id: 'acc-1', name: '당근 목걸이', price: 80, category: '액세서리'),
];

class HiveShopRepository implements ShopRepository {
  final Box _box;

  static const _ownedKey = 'shop_owned_ids';
  static const _equippedKey = 'shop_equipped_ids';

  HiveShopRepository(this._box);

  Set<String> get _ownedIds =>
      Set<String>.from((_box.get(_ownedKey) as List?)?.cast<String>() ?? []);

  Set<String> get _equippedIds =>
      Set<String>.from((_box.get(_equippedKey) as List?)?.cast<String>() ?? []);

  @override
  Future<List<ShopItem>> getItems() async {
    final owned = _ownedIds;
    return _defaultItems
        .map((item) => item.copyWith(isOwned: owned.contains(item.id)))
        .toList();
  }

  @override
  Future<List<ShopItem>> getOwnedItems() async {
    final owned = _ownedIds;
    return _defaultItems
        .where((item) => owned.contains(item.id))
        .map((item) => item.copyWith(isOwned: true))
        .toList();
  }

  @override
  Future<void> purchaseItem({
    required String itemId,
    required int currentPoints,
  }) async {
    final owned = _ownedIds;
    if (owned.contains(itemId)) {
      throw Exception('이미 보유한 아이템입니다.');
    }
    final item = _defaultItems.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw Exception('아이템을 찾을 수 없습니다.'),
    );
    if (currentPoints < item.price) {
      throw Exception('당근이 부족해요!');
    }
    owned.add(itemId);
    await _box.put(_ownedKey, owned.toList());
  }

  @override
  Future<List<ShopItem>> getEquippedItems() async {
    final equipped = _equippedIds;
    return _defaultItems
        .where((item) => equipped.contains(item.id))
        .map((item) => item.copyWith(isOwned: true))
        .toList();
  }

  @override
  Future<void> equipItem({required String itemId}) async {
    if (!_ownedIds.contains(itemId)) {
      throw Exception('보유하지 않은 아이템입니다.');
    }
    final equipped = _equippedIds;
    equipped.add(itemId);
    await _box.put(_equippedKey, equipped.toList());
  }

  @override
  Future<void> unequipItem({required String itemId}) async {
    final equipped = _equippedIds;
    equipped.remove(itemId);
    await _box.put(_equippedKey, equipped.toList());
  }
}
