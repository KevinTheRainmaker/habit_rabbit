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

    testWidgets('달성률 70% 이상이면 긍정 메시지 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompletionRateCard(rate: 0.7),
          ),
        ),
      );

      expect(find.text('잘하고 있어!'), findsOneWidget);
    });

    testWidgets('달성률 70% 미만이면 긍정 메시지 미표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompletionRateCard(rate: 0.69),
          ),
        ),
      );

      expect(find.text('잘하고 있어!'), findsNothing);
    });
  });
}
