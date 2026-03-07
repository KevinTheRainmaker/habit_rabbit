import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';

class InMemorySubscriptionRepository implements SubscriptionRepository {
  bool _isPremium = false;

  @override
  Future<bool> isPremium() async => _isPremium;

  @override
  Future<bool> purchasePremium() async {
    _isPremium = true;
    return true;
  }

  @override
  Future<bool> restorePurchases() async => _isPremium;
}
