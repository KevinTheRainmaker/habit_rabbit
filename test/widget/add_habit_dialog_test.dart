import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/add_habit_dialog.dart';

void main() {
  group('AddHabitDialog', () {
    testWidgets('습관 이름 입력 필드 존재', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AddHabitDialog()),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('저장 버튼 존재', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AddHabitDialog()),
          ),
        ),
      );

      expect(find.text('저장'), findsOneWidget);
    });

    testWidgets('이름 없이 저장 시 유효성 오류 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AddHabitDialog()),
          ),
        ),
      );

      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(find.text('습관 이름을 입력해주세요'), findsOneWidget);
    });

    testWidgets('이름 입력 후 저장 시 콜백 호출', (tester) async {
      String? savedName;
      List<int>? savedDays;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddHabitDialog(
                onSaved: (name, days, icon) {
                  savedName = name;
                  savedDays = days;
                },
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '매일 운동');
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedName, equals('매일 운동'));
      expect(savedDays, isNotNull);
    });

    testWidgets('아이콘 선택 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AddHabitDialog()),
          ),
        ),
      );

      expect(find.textContaining('🏃'), findsOneWidget);
    });

    testWidgets('아이콘 선택 시 선택된 아이콘 업데이트', (tester) async {
      String? savedIcon;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddHabitDialog(
                onSaved: (name, days, icon) {
                  savedIcon = icon;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('🏃'));
      await tester.pump();

      await tester.enterText(find.byType(TextField), '운동');
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedIcon, equals('🏃'));
    });

    testWidgets('요일 선택 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AddHabitDialog()),
          ),
        ),
      );

      expect(find.text('월'), findsOneWidget);
      expect(find.text('화'), findsOneWidget);
      expect(find.text('수'), findsOneWidget);
    });

    testWidgets('요일 선택 후 저장 시 해당 targetDays 전달', (tester) async {
      List<int>? savedDays;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddHabitDialog(
                onSaved: (name, days, icon) => savedDays = days,
              ),
            ),
          ),
        ),
      );

      // '월' 버튼만 탭 (기본 전체 선택 해제 후 월만 선택)
      // 먼저 전체 선택 해제: 모든 요일 탭
      for (final day in ['월', '화', '수', '목', '금', '토', '일']) {
        await tester.tap(find.text(day));
        await tester.pump();
      }
      // 월만 다시 선택
      await tester.tap(find.text('월'));
      await tester.pump();

      await tester.enterText(find.byType(TextField), '매일 운동');
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedDays, contains(0)); // 0 = 월요일 (0-based index)
    });

    // RED: 요일 미선택 시 저장 불가
    testWidgets('요일 미선택 시 저장 불가 에러 메시지 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: SingleChildScrollView(child: AddHabitDialog())),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 이름 입력
      await tester.enterText(find.byType(TextField), '매일 운동');

      // 모든 요일 해제 (기본 전체 선택 → 모두 탭해서 해제)
      for (final day in ['월', '화', '수', '목', '금', '토', '일']) {
        await tester.tap(find.text(day));
        await tester.pump();
      }

      // 저장 시도
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(find.textContaining('최소 하나의 요일'), findsOneWidget);
    });
  });
}
