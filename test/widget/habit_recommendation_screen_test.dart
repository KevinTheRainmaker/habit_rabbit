import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/habit_recommendation_screen.dart';

void main() {
  group('HabitRecommendationScreen', () {
    testWidgets('추천 습관 목록 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(
            onStart: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 최소 2개 이상의 추천 습관 표시
      expect(find.byType(CheckboxListTile), findsAtLeast(2));
    });

    testWidgets('습관 선택/해제 토글', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(
            onStart: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 첫 번째 체크박스 탭 → 선택
      final firstCheckbox = find.byType(CheckboxListTile).first;
      await tester.tap(firstCheckbox);
      await tester.pumpAndSettle();

      final checkboxWidget = tester.widget<CheckboxListTile>(firstCheckbox);
      expect(checkboxWidget.value, isTrue);
    });

    testWidgets('시작하기 버튼 존재', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(
            onStart: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('시작하기'), findsOneWidget);
    });

    testWidgets('선택된 습관으로 onStart 콜백 호출', (tester) async {
      List<String>? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(
            onStart: (habits) => selected = habits,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 첫 번째 습관 선택
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();

      // 시작하기 버튼 탭
      await tester.tap(find.text('시작하기'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.length, equals(1));
    });
  });
}
