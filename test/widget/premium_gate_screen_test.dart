import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';
import 'package:habit_rabbit/presentation/providers/subscription_provider.dart';
import 'package:habit_rabbit/presentation/screens/premium_gate_screen.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  group('PremiumGateScreen', () {
    testWidgets('프리미엄 업셀 메시지 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PremiumGateScreen(),
          ),
        ),
      );

      expect(find.textContaining('프리미엄'), findsWidgets);
    });

    testWidgets('닫기 버튼 존재', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PremiumGateScreen()),
          ),
        ),
      );

      expect(find.text('나중에'), findsOneWidget);
    });

    testWidgets('당근 포인트 안내 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PremiumGateScreen(),
          ),
        ),
      );

      expect(find.textContaining('습관'), findsWidgets);
    });

    testWidgets('무료 vs 유료 기능 비교 목록 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: PremiumGateScreen())),
          ),
        ),
      );

      expect(find.textContaining('무제한'), findsWidgets);
      expect(find.textContaining('통계'), findsWidgets);
      expect(find.textContaining('복구권'), findsWidgets);
    });

    testWidgets('업그레이드 CTA 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PremiumGateScreen(),
          ),
        ),
      );

      expect(find.textContaining('업그레이드'), findsWidgets);
    });

    testWidgets('나중에 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PremiumGateScreen()),
          ),
        ),
      );

      expect(find.textContaining('나중에'), findsOneWidget);
    });

    testWidgets('구독 복원 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: PremiumGateScreen())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('구독 복원'), findsOneWidget);
    });

    testWidgets('업그레이드 탭 시 프리미엄 토끼 축하 메시지 표시', (tester) async {
      final mockRepo = MockSubscriptionRepository();
      when(() => mockRepo.purchasePremium()).thenAnswer((_) async => true);
      when(() => mockRepo.isPremium()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: PremiumGateScreen()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('업그레이드하기'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('프리미엄 토끼가 됐어요'), findsOneWidget);
    });

    // RED: 업그레이드 버튼 탭 시 purchasePremium 호출 검증
    testWidgets('업그레이드 버튼 탭 시 purchasePremium 호출', (tester) async {
      final mockRepo = MockSubscriptionRepository();
      when(() => mockRepo.purchasePremium()).thenAnswer((_) async => true);
      when(() => mockRepo.isPremium()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: PremiumGateScreen())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('업그레이드하기'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.purchasePremium()).called(1);
    });

    // RED: 업그레이드 후 isPremiumProvider 갱신 (invalidate → isPremium 재호출)
    testWidgets('업그레이드 후 isPremiumProvider 갱신', (tester) async {
      final mockRepo = MockSubscriptionRepository();
      when(() => mockRepo.purchasePremium()).thenAnswer((_) async => true);
      when(() => mockRepo.isPremium()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            subscriptionRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // isPremiumProvider를 구독하는 위젯 (invalidate 후 재fetch 트리거)
                  Consumer(builder: (context, ref, _) {
                    ref.watch(isPremiumProvider);
                    return const SizedBox();
                  }),
                  const Expanded(
                    child: SingleChildScrollView(child: PremiumGateScreen()),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      clearInteractions(mockRepo);

      await tester.tap(find.textContaining('업그레이드하기'));
      await tester.pumpAndSettle();

      // ref.invalidate(isPremiumProvider) 호출 시 isPremium()이 재호출됨
      verify(() => mockRepo.isPremium()).called(1);
    });
  });
}
