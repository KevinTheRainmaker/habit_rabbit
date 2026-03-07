import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  group('HabitListScreen', () {
    testWidgets('앱바에 "내 습관" 타이틀 표시', (tester) async {
      final mock = MockHabitRepository();
      when(() => mock.getHabits(userId: any(named: 'userId')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mock)],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );

      expect(find.text('내 습관'), findsOneWidget);
    });

    testWidgets('습관 추가 버튼(FAB) 존재', (tester) async {
      final mock = MockHabitRepository();
      when(() => mock.getHabits(userId: any(named: 'userId')))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mock)],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
