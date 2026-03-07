import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/domain/repositories/shop_repository.dart';
import 'package:habit_rabbit/presentation/providers/carrot_points_provider.dart';

import 'package:habit_rabbit/presentation/providers/shop_provider.dart';
import 'package:habit_rabbit/presentation/screens/customization_screen.dart';
import 'package:habit_rabbit/presentation/screens/shop_screen.dart';

class MockShopRepository extends Mock implements ShopRepository {}

void main() {
  final testItems = [
    const ShopItem(id: 'hat-1', name: '토끼 모자', price: 100, category: '의상'),
    const ShopItem(id: 'hat-2', name: '마법사 모자', price: 200, category: '의상'),
    const ShopItem(id: 'bg-1', name: '꽃밭 배경', price: 150, category: '배경',
        isOwned: true),
  ];

  group('ShopScreen', () {
    testWidgets('아이템 목록 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getItems()).thenAnswer((_) async => testItems);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(home: ShopScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('토끼 모자'), findsOneWidget);
      expect(find.text('마법사 모자'), findsOneWidget);
    });

    testWidgets('소유한 아이템에 "보유" 배지 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getItems()).thenAnswer((_) async => testItems);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(home: ShopScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('보유'), findsOneWidget);
    });

    testWidgets('잔액 부족 시 "당근이 부족해요" 스낵바 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getItems()).thenAnswer((_) async => testItems);
      when(() => mockRepo.purchaseItem(
            itemId: any(named: 'itemId'),
            currentPoints: any(named: 'currentPoints'),
          )).thenThrow(Exception('당근이 부족해요!'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            shopRepositoryProvider.overrideWithValue(mockRepo),
            carrotPointsProvider.overrideWith(CarrotPointsNotifier.new),
          ],
          child: const MaterialApp(home: ShopScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // 구매 버튼 탭 (미소유 아이템 첫 번째: 토끼 모자)
      await tester.tap(find.text('구매').first);
      await tester.pumpAndSettle();

      expect(find.textContaining('당근이 부족'), findsOneWidget);
    });

    testWidgets('"꾸미기" 버튼 탭 시 CustomizationScreen으로 이동', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getItems()).thenAnswer((_) async => testItems);
      when(() => mockRepo.getOwnedItems()).thenAnswer((_) async => []);
      when(() => mockRepo.getEquippedItems()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [shopRepositoryProvider.overrideWithValue(mockRepo)],
          child: const MaterialApp(home: ShopScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.palette));
      await tester.pumpAndSettle();

      expect(find.byType(CustomizationScreen), findsOneWidget);
    });
  });
}
