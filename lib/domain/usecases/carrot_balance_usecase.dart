import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';

class CarrotBalanceUseCase {
  final List<Checkin> checkins;
  final List<ShopItem> ownedItems;

  const CarrotBalanceUseCase({
    required this.checkins,
    required this.ownedItems,
  });

  int get balance {
    final earned = checkins.fold(0, (sum, c) => sum + c.carrotPoints);
    final spent = ownedItems.fold(0, (sum, i) => sum + i.price);
    return (earned - spent).clamp(0, earned);
  }
}
