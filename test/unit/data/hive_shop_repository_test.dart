import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_shop_repository.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveShopRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_shop_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('shop_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveShopRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveShopRepository', () {
    test('초기 아이템 목록 반환', () async {
      final items = await repo.getItems();
      expect(items, isNotEmpty);
    });

    test('초기에는 보유 아이템 없음', () async {
      final owned = await repo.getOwnedItems();
      expect(owned, isEmpty);
    });

    test('구매 후 getOwnedItems에 포함됨', () async {
      final items = await repo.getItems();
      final item = items.first;

      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);
      final owned = await repo.getOwnedItems();

      expect(owned.any((i) => i.id == item.id), isTrue);
    });

    test('이미 보유한 아이템 재구매 시 예외', () async {
      final items = await repo.getItems();
      final item = items.first;
      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);

      expect(
        () => repo.purchaseItem(itemId: item.id, currentPoints: 9999),
        throwsException,
      );
    });

    test('포인트 부족 시 예외', () async {
      final items = await repo.getItems();
      final item = items.first;

      expect(
        () => repo.purchaseItem(itemId: item.id, currentPoints: 0),
        throwsException,
      );
    });

    test('구매 후 장착하면 getEquippedItems에 포함됨', () async {
      final items = await repo.getItems();
      final item = items.first;
      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);
      await repo.equipItem(itemId: item.id);

      final equipped = await repo.getEquippedItems();
      expect(equipped.any((i) => i.id == item.id), isTrue);
    });

    test('해제 후 getEquippedItems에서 제외됨', () async {
      final items = await repo.getItems();
      final item = items.first;
      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);
      await repo.equipItem(itemId: item.id);
      await repo.unequipItem(itemId: item.id);

      final equipped = await repo.getEquippedItems();
      expect(equipped.any((i) => i.id == item.id), isFalse);
    });

    test('Box를 재생성해도 구매 정보 유지 (영속성)', () async {
      final items = await repo.getItems();
      final item = items.first;
      await repo.purchaseItem(itemId: item.id, currentPoints: 9999);

      // 같은 box로 새 repository 생성
      final repo2 = HiveShopRepository(box);
      final owned = await repo2.getOwnedItems();
      expect(owned.any((i) => i.id == item.id), isTrue);
    });
  });
}
