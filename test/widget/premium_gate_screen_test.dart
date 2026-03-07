import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/premium_gate_screen.dart';

void main() {
  group('PremiumGateScreen', () {
    testWidgets('프리미엄 업셀 메시지 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PremiumGateScreen(),
        ),
      );

      expect(find.textContaining('프리미엄'), findsWidgets);
    });

    testWidgets('닫기 버튼 존재', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PremiumGateScreen()),
        ),
      );

      expect(find.text('닫기'), findsOneWidget);
    });

    testWidgets('당근 포인트 안내 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PremiumGateScreen(),
        ),
      );

      expect(find.textContaining('습관'), findsWidgets);
    });
  });
}
