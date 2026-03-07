import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';
import 'package:habit_rabbit/presentation/providers/subscription_provider.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository mockRepo;

  setUp(() {
    mockRepo = MockSubscriptionRepository();
  });

  group('isPremiumProvider', () {
    test('초기 상태: isPremium false', () async {
      when(() => mockRepo.isPremium()).thenAnswer((_) async => false);

      final container = ProviderContainer(
        overrides: [
          subscriptionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(isPremiumProvider.future);
      expect(result, isFalse);
    });

    test('isPremium true이면 true 반환', () async {
      when(() => mockRepo.isPremium()).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          subscriptionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(isPremiumProvider.future);
      expect(result, isTrue);
    });
  });
}
