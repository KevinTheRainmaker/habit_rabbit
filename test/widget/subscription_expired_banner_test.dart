import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/widgets/subscription_expired_banner.dart';

void main() {
  group('SubscriptionExpiredBanner', () {
    testWidgets('wasEverPremium=true, isPremium=false이면 만료 배너 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SubscriptionExpiredBanner(
              isPremium: false,
              wasEverPremium: true,
              onRenew: null,
            ),
          ),
        ),
      );

      expect(find.textContaining('구독이 만료'), findsOneWidget);
    });

    testWidgets('isPremium=true이면 만료 배너 미표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SubscriptionExpiredBanner(
              isPremium: true,
              wasEverPremium: true,
              onRenew: null,
            ),
          ),
        ),
      );

      expect(find.textContaining('구독이 만료'), findsNothing);
    });

    testWidgets('wasEverPremium=false이면 만료 배너 미표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SubscriptionExpiredBanner(
              isPremium: false,
              wasEverPremium: false,
              onRenew: null,
            ),
          ),
        ),
      );

      expect(find.textContaining('구독이 만료'), findsNothing);
    });
  });
}
