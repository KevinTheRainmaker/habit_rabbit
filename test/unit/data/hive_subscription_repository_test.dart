import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_subscription_repository.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveSubscriptionRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_sub_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('sub_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveSubscriptionRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveSubscriptionRepository', () {
    test('초기 프리미엄 상태 false', () async {
      expect(await repo.isPremium(), false);
    });

    test('purchasePremium 후 isPremium=true', () async {
      await repo.purchasePremium();
      expect(await repo.isPremium(), true);
    });

    test('purchasePremium 후 Box 재생성해도 isPremium=true 영속', () async {
      await repo.purchasePremium();
      final repo2 = HiveSubscriptionRepository(box);
      expect(await repo2.isPremium(), true);
    });

    test('restorePurchases는 현재 상태 반환', () async {
      expect(await repo.restorePurchases(), false);
      await repo.purchasePremium();
      expect(await repo.restorePurchases(), true);
    });
  });
}
