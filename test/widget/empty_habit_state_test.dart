import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/widgets/empty_habit_state.dart';

void main() {
  group('EmptyHabitState', () {
    testWidgets('첫 습관 추가 안내 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyHabitState(onAdd: () {}),
          ),
        ),
      );
      expect(find.textContaining('습관'), findsWidgets);
    });

    testWidgets('"첫 습관 추가하기" 버튼 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyHabitState(onAdd: () {}),
          ),
        ),
      );
      expect(find.text('첫 습관 추가하기'), findsOneWidget);
    });

    testWidgets('"첫 습관 추가하기" 탭 시 onAdd 호출', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyHabitState(onAdd: () => called = true),
          ),
        ),
      );
      await tester.tap(find.text('첫 습관 추가하기'));
      expect(called, isTrue);
    });
  });
}
