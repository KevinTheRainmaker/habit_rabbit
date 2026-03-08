import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/domain/usecases/carrot_balance_usecase.dart';

void main() {
  group('CarrotBalanceUseCase', () {
    test('체크인도 구매도 없으면 0', () {
      final useCase = CarrotBalanceUseCase(checkins: [], ownedItems: []);
      expect(useCase.balance, 0);
    });

    test('구매 없으면 획득 총합이 잔액', () {
      final checkins = [
        Checkin(
          id: 'c1',
          habitId: 'h1',
          userId: 'u1',
          date: DateTime(2026, 3, 1),
          streakDay: 1,
        ),
      ];
      final useCase = CarrotBalanceUseCase(checkins: checkins, ownedItems: []);
      expect(useCase.balance, checkins.first.carrotPoints);
    });

    test('체크인 획득 - 구매 지출 = 잔액 (획득이 더 많은 경우)', () {
      // 10개 체크인 = 100포인트, 아이템 가격 80 → 잔액 20
      final checkins = List.generate(
        10,
        (i) => Checkin(
          id: 'c$i',
          habitId: 'h1',
          userId: 'u1',
          date: DateTime(2026, 3, i + 1),
          streakDay: i,
        ),
      );
      const ownedItems = [
        ShopItem(id: 'acc-1', name: '당근 목걸이', price: 80, category: '액세서리', isOwned: true),
      ];
      final earned = checkins.fold(0, (s, c) => s + c.carrotPoints);
      final useCase = CarrotBalanceUseCase(checkins: checkins, ownedItems: ownedItems);
      expect(useCase.balance, earned - 80);
    });

    test('잔액이 음수가 되지 않음 (구매가 획득보다 많은 경우)', () {
      const ownedItems = [
        ShopItem(id: 'hat-1', name: '토끼 모자', price: 9999, category: '의상', isOwned: true),
      ];
      final useCase = CarrotBalanceUseCase(checkins: [], ownedItems: ownedItems);
      expect(useCase.balance, 0);
    });
  });
}
