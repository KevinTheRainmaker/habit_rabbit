import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habit_rabbit/main.dart';

void main() {
  testWidgets('HabitRabbitApp smoke test — renders without crash',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HabitRabbitApp()),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
