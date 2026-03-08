import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/widgets/premium_teaser_banner.dart';

void main() {
  group('PremiumTeaserBanner', () {
    testWidgets('무료 사용자에게 티저 배너 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumTeaserBanner(
              isPremium: false,
              onUpgrade: () {},
            ),
          ),
        ),
      );
      expect(find.textContaining('구독'), findsWidgets);
    });

    testWidgets('"업그레이드하기" 버튼 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumTeaserBanner(
              isPremium: false,
              onUpgrade: () {},
            ),
          ),
        ),
      );
      expect(find.text('업그레이드하기'), findsOneWidget);
    });

    testWidgets('"업그레이드하기" 탭 시 onUpgrade 호출', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumTeaserBanner(
              isPremium: false,
              onUpgrade: () => called = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('업그레이드하기'));
      expect(called, isTrue);
    });

    testWidgets('프리미엄 사용자에게 티저 미표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumTeaserBanner(
              isPremium: true,
              onUpgrade: () {},
            ),
          ),
        ),
      );
      expect(find.text('업그레이드하기'), findsNothing);
    });
  });
}
