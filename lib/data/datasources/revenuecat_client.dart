abstract class RevenueCatClient {
  Future<bool> isPremiumActive();
  Future<bool> purchasePremiumPackage();
  Future<bool> restorePurchases();
}
