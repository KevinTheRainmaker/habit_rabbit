import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/habit_recommendation_screen.dart';

void main() {
  group('HabitRecommendationScreen', () {
    testWidgets('추천 습관 목록 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(onStart: (_) {}),
        ),
      );

      expect(find.text('매일 물 8잔 마시기'), findsOneWidget);
    });

    testWidgets('1개 선택 시 "완벽한 시작이에요!" 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(onStart: (_) {}),
        ),
      );

      await tester.tap(find.text('매일 물 8잔 마시기'));
      await tester.pump();

      expect(find.text('완벽한 시작이에요!'), findsOneWidget);
    });

    testWidgets('2개 이상 선택 시 "처음엔 적을수록 좋아요" 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(onStart: (_) {}),
        ),
      );

      await tester.tap(find.text('매일 물 8잔 마시기'));
      await tester.pump();
      await tester.tap(find.text('10분 스트레칭'));
      await tester.pump();

      expect(find.text('처음엔 적을수록 좋아요'), findsOneWidget);
    });

    testWidgets('"오늘은 1개만 시작해요" 강조 텍스트 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(onStart: (_) {}),
        ),
      );

      expect(find.text('오늘은 1개만 시작해요'), findsOneWidget);
    });

    testWidgets('아침 루틴 답변 시 아침 관련 습관 추천 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HabitRecommendationScreen(
            onStart: (_) {},
            answers: const ['건강한 몸 만들기', '아침 (기상 후)', '처음이에요'],
          ),
        ),
      );

      expect(find.textContaining('스트레칭'), findsWidgets);
    });
  });
}
