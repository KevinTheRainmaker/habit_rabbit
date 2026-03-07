import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;

  setUp(() {
    repository = MockSubscriptionRepository();
  });

  group('SubscriptionRepository', () {
    test('isPremium: 구독 상태 반환', () async {
      when(() => repository.isPremium()).thenAnswer((_) async => false);

      final result = await repository.isPremium();

      expect(result, isFalse);
    });

    test('purchasePremium: 성공 시 true 반환', () async {
      when(() => repository.purchasePremium()).thenAnswer((_) async => true);

      final result = await repository.purchasePremium();

      expect(result, isTrue);
    });

    test('restorePurchases: 복원 후 상태 반환', () async {
      when(() => repository.restorePurchases()).thenAnswer((_) async => true);

      final result = await repository.restorePurchases();

      expect(result, isTrue);
    });
  });
}
