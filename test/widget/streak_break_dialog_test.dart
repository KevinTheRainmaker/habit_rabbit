import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/streak_break_dialog.dart';

void main() {
  group('StreakBreakDialog', () {
    Widget buildDialog({bool freeTrialUsed = false}) {
      return MaterialApp(
        home: Scaffold(
          body: StreakBreakDialog(
            freeTrialUsed: freeTrialUsed,
            onUseFreeRecovery: () {},
            onRestart: () {},
          ),
        ),
      );
    }

    testWidgets('위로 메시지 표시', (tester) async {
      await tester.pumpWidget(buildDialog());
      expect(find.textContaining('괜찮아'), findsWidgets);
    });

    testWidgets('"무료 복구권 사용하기" 버튼 표시 (미사용 시)', (tester) async {
      await tester.pumpWidget(buildDialog());
      expect(find.text('무료 복구권 사용하기'), findsOneWidget);
    });

    testWidgets('"괜찮아, 다시 시작할게" 버튼 표시', (tester) async {
      await tester.pumpWidget(buildDialog());
      expect(find.text('괜찮아, 다시 시작할게'), findsOneWidget);
    });

    testWidgets('무료 체험 이미 사용 시 복구권 버튼 비활성화', (tester) async {
      await tester.pumpWidget(buildDialog(freeTrialUsed: true));
      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('무료 복구권 사용하기'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });
  });
}
