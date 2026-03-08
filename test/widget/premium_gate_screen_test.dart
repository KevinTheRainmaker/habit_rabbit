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

      expect(find.text('나중에'), findsOneWidget);
    });

    testWidgets('당근 포인트 안내 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PremiumGateScreen(),
        ),
      );

      expect(find.textContaining('습관'), findsWidgets);
    });

    testWidgets('무료 vs 유료 기능 비교 목록 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: PremiumGateScreen())),
        ),
      );

      expect(find.textContaining('무제한'), findsWidgets);
      expect(find.textContaining('통계'), findsWidgets);
      expect(find.textContaining('복구권'), findsWidgets);
    });

    testWidgets('업그레이드 CTA 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PremiumGateScreen(),
        ),
      );

      expect(find.textContaining('업그레이드'), findsWidgets);
    });

    testWidgets('나중에 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PremiumGateScreen()),
        ),
      );

      expect(find.textContaining('나중에'), findsOneWidget);
    });
  });
}
