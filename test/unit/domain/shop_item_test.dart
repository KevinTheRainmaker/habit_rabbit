import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';

void main() {
  group('ShopItem', () {
    test('같은 id는 동일하다', () {
      const a = ShopItem(id: 'item-1', name: '토끼 모자', price: 100, category: '의상');
      const b = ShopItem(id: 'item-1', name: '다른 이름', price: 200, category: '의상');
      expect(a, equals(b));
    });

    test('다른 id는 다르다', () {
      const a = ShopItem(id: 'item-1', name: '토끼 모자', price: 100, category: '의상');
      const b = ShopItem(id: 'item-2', name: '토끼 모자', price: 100, category: '의상');
      expect(a, isNot(equals(b)));
    });

    test('isOwned 기본값은 false', () {
      const item = ShopItem(id: 'item-1', name: '토끼 모자', price: 100, category: '의상');
      expect(item.isOwned, isFalse);
    });

    test('copyWith으로 isOwned 변경', () {
      const item = ShopItem(id: 'item-1', name: '토끼 모자', price: 100, category: '의상');
      final owned = item.copyWith(isOwned: true);
      expect(owned.isOwned, isTrue);
      expect(owned.id, equals('item-1'));
    });
  });
}
