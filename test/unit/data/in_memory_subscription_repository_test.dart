import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_subscription_repository.dart';

void main() {
  group('InMemorySubscriptionRepository', () {
    test('초기 상태: isPremium false', () async {
      final repo = InMemorySubscriptionRepository();
      expect(await repo.isPremium(), isFalse);
    });

    test('purchasePremium: true 반환 후 isPremium true', () async {
      final repo = InMemorySubscriptionRepository();
      final result = await repo.purchasePremium();
      expect(result, isTrue);
      expect(await repo.isPremium(), isTrue);
    });

    test('restorePurchases: 구매 기록 없으면 false', () async {
      final repo = InMemorySubscriptionRepository();
      expect(await repo.restorePurchases(), isFalse);
    });

    test('restorePurchases: 구매 후 복원하면 true', () async {
      final repo = InMemorySubscriptionRepository();
      await repo.purchasePremium();
      expect(await repo.restorePurchases(), isTrue);
    });
  });
}
