import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';

class HiveSubscriptionRepository implements SubscriptionRepository {
  final Box _box;

  static const _premiumKey = 'is_premium';

  HiveSubscriptionRepository(this._box);

  @override
  Future<bool> isPremium() async =>
      (_box.get(_premiumKey) as bool?) ?? false;

  @override
  Future<bool> purchasePremium() async {
    await _box.put(_premiumKey, true);
    return true;
  }

  @override
  Future<bool> restorePurchases() async => isPremium();
}
