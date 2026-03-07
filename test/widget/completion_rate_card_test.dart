import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/widgets/completion_rate_card.dart';

void main() {
  group('CompletionRateCard', () {
    testWidgets('달성률 71% 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompletionRateCard(rate: 0.71),
          ),
        ),
      );

      expect(find.textContaining('71%'), findsOneWidget);
    });

    testWidgets('달성률 100% 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompletionRateCard(rate: 1.0),
          ),
        ),
      );

      expect(find.textContaining('100%'), findsOneWidget);
    });

    testWidgets('달성률 0%일 때 격려 메시지 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompletionRateCard(rate: 0.0),
          ),
        ),
      );

      expect(find.textContaining('오늘 첫 체크인'), findsOneWidget);
    });
  });
}
