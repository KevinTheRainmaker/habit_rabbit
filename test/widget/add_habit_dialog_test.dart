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

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AddHabitDialog(
                onSaved: (name) => savedName = name,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '매일 운동');
      await tester.tap(find.text('저장'));
      await tester.pump();

      expect(savedName, equals('매일 운동'));
    });
  });
}
