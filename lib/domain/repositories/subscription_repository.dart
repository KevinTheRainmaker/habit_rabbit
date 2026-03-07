abstract class SubscriptionRepository {
  Future<bool> isPremium();
  Future<bool> purchasePremium();
  Future<bool> restorePurchases();
}
