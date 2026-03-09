import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/data/datasources/revenuecat_client.dart';
import 'package:habit_rabbit/data/repositories/revenuecat_subscription_repository.dart';

class MockRevenueCatClient extends Mock implements RevenueCatClient {}

void main() {
  late MockRevenueCatClient mockClient;
  late RevenueCatSubscriptionRepository repo;

  setUp(() {
    mockClient = MockRevenueCatClient();
    repo = RevenueCatSubscriptionRepository(client: mockClient);
  });

  group('RevenueCatSubscriptionRepository', () {
    test('isPremium: premium entitlement 활성화 시 true 반환', () async {
      when(() => mockClient.isPremiumActive()).thenAnswer((_) async => true);

      final result = await repo.isPremium();

      expect(result, true);
      verify(() => mockClient.isPremiumActive()).called(1);
    });

    test('isPremium: entitlement 없으면 false 반환', () async {
      when(() => mockClient.isPremiumActive()).thenAnswer((_) async => false);

      final result = await repo.isPremium();

      expect(result, false);
    });

    test('purchasePremium: 구매 성공 시 true 반환', () async {
      when(() => mockClient.purchasePremiumPackage())
          .thenAnswer((_) async => true);

      final result = await repo.purchasePremium();

      expect(result, true);
      verify(() => mockClient.purchasePremiumPackage()).called(1);
    });

    test('purchasePremium: 구매 실패/취소 시 false 반환', () async {
      when(() => mockClient.purchasePremiumPackage())
          .thenAnswer((_) async => false);

      final result = await repo.purchasePremium();

      expect(result, false);
    });

    test('restorePurchases: 복원 성공 시 true 반환', () async {
      when(() => mockClient.restorePurchases()).thenAnswer((_) async => true);

      final result = await repo.restorePurchases();

      expect(result, true);
      verify(() => mockClient.restorePurchases()).called(1);
    });

    test('restorePurchases: 복원할 구매 없으면 false 반환', () async {
      when(() => mockClient.restorePurchases()).thenAnswer((_) async => false);

      final result = await repo.restorePurchases();

      expect(result, false);
    });
  });
}
