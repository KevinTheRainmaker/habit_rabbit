import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/widgets/habit_readiness_card.dart';

void main() {
  group('HabitReadinessCard', () {
    testWidgets('7일 달성률 80% 이상 시 카드 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitReadinessCard(
              weeklyCompletionRate: 0.8,
              onAdd: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );
      expect(find.textContaining('습관'), findsWidgets);
    });

    testWidgets('"추가하기" 버튼 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitReadinessCard(
              weeklyCompletionRate: 0.85,
              onAdd: () {},
              onDismiss: () {},
            ),
          ),
        ),
      );
      expect(find.text('추가하기'), findsOneWidget);
    });

    testWidgets('"아직은 괜찮아" 버튼 탭 시 onDismiss 호출', (tester) async {
      bool dismissed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HabitReadinessCard(
              weeklyCompletionRate: 0.9,
              onAdd: () {},
              onDismiss: () => dismissed = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('아직은 괜찮아'));
      expect(dismissed, isTrue);
    });
  });
}
