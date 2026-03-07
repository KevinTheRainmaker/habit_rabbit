import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/main.dart';

void main() {
  group('HabitRabbitApp', () {
    testWidgets('앱이 정상적으로 렌더링된다', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: HabitRabbitApp()),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('앱 타이틀이 Habit Rabbit', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: HabitRabbitApp()),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('Habit Rabbit'));
    });
  });
}
