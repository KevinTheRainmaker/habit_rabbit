import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/presentation/screens/edit_habit_dialog.dart';

void main() {
  final testHabit = Habit(
    id: 'h-1',
    userId: 'uid-1',
    name: '운동',
    createdAt: DateTime(2026, 3, 7),
    isActive: true,
    targetDays: const [0, 1, 2, 3, 4, 5, 6],
  );

  group('EditHabitDialog', () {
    testWidgets('이름 필드에 기존 습관명 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EditHabitDialog(habit: testHabit)),
        ),
      );

      expect(find.widgetWithText(TextField, '운동'), findsOneWidget);
    });

    testWidgets('편집 다이얼로그에 요일 선택 버튼 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EditHabitDialog(habit: testHabit)),
        ),
      );

      expect(find.text('월'), findsOneWidget);
      expect(find.text('화'), findsOneWidget);
      expect(find.text('수'), findsOneWidget);
    });

    testWidgets('요일 수정 후 저장 시 업데이트된 targetDays 전달', (tester) async {
      List<int>? savedDays;

      final mondayOnlyHabit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
        targetDays: const [0],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditHabitDialog(
              habit: mondayOnlyHabit,
              onSaved: (name, days, icon) => savedDays = days,
            ),
          ),
        ),
      );

      await tester.tap(find.text('화'));
      await tester.pump();
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedDays, containsAll([0, 1]));
    });

    testWidgets('편집 다이얼로그에 아이콘 선택 버튼 표시', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EditHabitDialog(habit: testHabit)),
        ),
      );

      expect(find.text('🏃'), findsOneWidget);
    });

    testWidgets('아이콘 선택 후 저장 시 선택된 아이콘 전달', (tester) async {
      String? savedIcon;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditHabitDialog(
              habit: testHabit,
              onSaved: (name, days, icon) => savedIcon = icon,
            ),
          ),
        ),
      );

      await tester.tap(find.text('🏃'));
      await tester.pump();
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedIcon, '🏃');
    });
  });
}
