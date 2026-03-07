import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/shop_item.dart';
import 'package:habit_rabbit/domain/repositories/shop_repository.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';
import 'package:habit_rabbit/presentation/screens/customization_screen.dart';

class MockShopRepository extends Mock implements ShopRepository {}

void main() {
  final ownedItems = [
    const ShopItem(id: 'hat-1', name: '토끼 모자', price: 100, category: '의상', isOwned: true),
    const ShopItem(id: 'hat-2', name: '마법사 모자', price: 200, category: '의상', isOwned: true),
  ];

  group('CustomizationScreen', () {
    testWidgets('소유 아이템 목록 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getOwnedItems()).thenAnswer((_) async => ownedItems);
      when(() => mockRepo.getEquippedItems()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [shopRepositoryProvider.overrideWithValue(mockRepo)],
          child: const MaterialApp(home: CustomizationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('토끼 모자'), findsOneWidget);
      expect(find.text('마법사 모자'), findsOneWidget);
    });

    testWidgets('장착된 아이템에 "장착 중" 배지 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getOwnedItems()).thenAnswer((_) async => ownedItems);
      when(() => mockRepo.getEquippedItems())
          .thenAnswer((_) async => [ownedItems.first]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [shopRepositoryProvider.overrideWithValue(mockRepo)],
          child: const MaterialApp(home: CustomizationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('장착 중'), findsOneWidget);
    });

    testWidgets('앱바에 "꾸미기" 타이틀 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getOwnedItems()).thenAnswer((_) async => []);
      when(() => mockRepo.getEquippedItems()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [shopRepositoryProvider.overrideWithValue(mockRepo)],
          child: const MaterialApp(home: CustomizationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('꾸미기'), findsOneWidget);
    });

    testWidgets('소유 아이템이 없으면 안내 메시지 표시', (tester) async {
      final mockRepo = MockShopRepository();
      when(() => mockRepo.getOwnedItems()).thenAnswer((_) async => []);
      when(() => mockRepo.getEquippedItems()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [shopRepositoryProvider.overrideWithValue(mockRepo)],
          child: const MaterialApp(home: CustomizationScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('아이템을 구매'), findsOneWidget);
    });
  });
}
