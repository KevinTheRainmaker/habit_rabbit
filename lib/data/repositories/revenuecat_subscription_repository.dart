import 'package:habit_rabbit/data/datasources/purchases_wrapper.dart';
import 'package:habit_rabbit/data/datasources/revenuecat_client.dart';
import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';

class RevenueCatSubscriptionRepository implements SubscriptionRepository {
  final RevenueCatClient _client;

  RevenueCatSubscriptionRepository({RevenueCatClient? client})
      : _client = client ?? PurchasesWrapper();

  @override
  Future<bool> isPremium() => _client.isPremiumActive();

  @override
  Future<bool> purchasePremium() => _client.purchasePremiumPackage();

  @override
  Future<bool> restorePurchases() => _client.restorePurchases();
}
