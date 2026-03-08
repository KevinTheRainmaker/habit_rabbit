import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/widgets/premium_blur_overlay.dart';

void main() {
  group('PremiumBlurOverlay', () {
    testWidgets('무료 사용자에게 업그레이드 CTA 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumBlurOverlay(
              isPremium: false,
              onUpgrade: () {},
              child: const Text('심화 통계'),
            ),
          ),
        ),
      );

      expect(find.textContaining('구독하면'), findsOneWidget);
      expect(find.textContaining('업그레이드'), findsOneWidget);
    });

    testWidgets('유료 사용자에게 업그레이드 CTA 미표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumBlurOverlay(
              isPremium: true,
              onUpgrade: () {},
              child: const Text('심화 통계'),
            ),
          ),
        ),
      );

      expect(find.textContaining('구독하면'), findsNothing);
    });

    testWidgets('자식 위젯은 항상 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumBlurOverlay(
              isPremium: false,
              onUpgrade: () {},
              child: const Text('심화 통계'),
            ),
          ),
        ),
      );

      expect(find.text('심화 통계'), findsOneWidget);
    });
  });
}
