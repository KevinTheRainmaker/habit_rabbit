import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/presentation/screens/edit_habit_dialog.dart';

void main() {
  final habit = Habit(
    id: 'h-1',
    userId: 'uid-1',
    name: '매일 운동',
    createdAt: DateTime(2026, 3, 7),
    isActive: true,
  );

  group('EditHabitDialog', () {
    testWidgets('기존 이름 미리 채워짐', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: EditHabitDialog(habit: habit)),
          ),
        ),
      );

      expect(find.widgetWithText(TextField, '매일 운동'), findsOneWidget);
    });

    testWidgets('저장 버튼 존재', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: EditHabitDialog(habit: habit)),
          ),
        ),
      );

      expect(find.text('저장'), findsOneWidget);
    });

    testWidgets('빈 이름 저장 시 유효성 오류 표시', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: EditHabitDialog(habit: habit)),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(find.text('습관 이름을 입력해주세요'), findsOneWidget);
    });

    testWidgets('이름 수정 후 저장 시 콜백 호출', (tester) async {
      String? savedName;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EditHabitDialog(
                habit: habit,
                onSaved: (name) => savedName = name,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.enterText(find.byType(TextField), '매일 독서');
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedName, equals('매일 독서'));
    });
  });
}
