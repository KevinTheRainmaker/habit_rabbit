import 'package:purchases_flutter/purchases_flutter.dart';
import 'revenuecat_client.dart';

class PurchasesWrapper implements RevenueCatClient {
  static const _entitlementId = 'premium';

  @override
  Future<bool> isPremiumActive() async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(_entitlementId);
  }

  @override
  Future<bool> purchasePremiumPackage() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.monthly;
      if (package == null) return false;
      final info = await Purchases.purchasePackage(package);
      return info.entitlements.active.containsKey(_entitlementId);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    return info.entitlements.active.containsKey(_entitlementId);
  }
}
