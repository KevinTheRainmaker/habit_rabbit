import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/onboarding_screen.dart';

void main() {
  group('OnboardingScreen', () {
    testWidgets('온보딩 첫 질문 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: (_) {},
            onSkip: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('목표'), findsOneWidget);
    });

    testWidgets('건너뛰기 버튼 존재', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: (_) {},
            onSkip: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('건너뛰기'), findsOneWidget);
    });

    testWidgets('건너뛰기 탭 시 onSkip 콜백 호출', (tester) async {
      bool skipped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: (_) {},
            onSkip: () => skipped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('건너뛰기'));
      await tester.pumpAndSettle();

      expect(skipped, isTrue);
    });

    testWidgets('답변 선택 후 다음 버튼으로 진행', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: (_) {},
            onSkip: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 첫 번째 선택지 탭
      final firstOption = find.byType(ListTile).first;
      await tester.tap(firstOption);
      await tester.pumpAndSettle();

      // 다음 버튼 탭
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 두 번째 질문으로 이동 확인 (진행 표시자 변화)
      expect(find.text('2 / 3'), findsOneWidget);
    });

    testWidgets('마지막 질문 완료 시 onCompleted 콜백 호출', (tester) async {
      List<String>? receivedAnswers;
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(
            onCompleted: (answers) => receivedAnswers = answers,
            onSkip: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 3번 질문 모두 완료
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();

        final buttonText = i < 2 ? '다음' : '완료';
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();
      }

      expect(receivedAnswers, isNotNull);
      expect(receivedAnswers!.length, equals(3));
    });
  });
}
