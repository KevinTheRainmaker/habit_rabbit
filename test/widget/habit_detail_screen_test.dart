import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_detail_screen.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  final habit = Habit(
    id: 'h-1',
    userId: 'uid-1',
    name: '매일 운동',
    createdAt: DateTime(2026, 3, 1),
    isActive: true,
  );

  const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);

  group('HabitDetailScreen', () {
    testWidgets('습관 이름 표시', (tester) async {
      final mockRepo = MockHabitRepository();
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: HabitDetailScreen(habit: habit, user: user),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('매일 운동'), findsOneWidget);
    });

    testWidgets('현재 스트릭 표시', (tester) async {
      final mockRepo = MockHabitRepository();
      final today = DateTime.now();
      final checkins = [
        Checkin(
          id: 'c-1',
          habitId: 'h-1',
          userId: 'uid-1',
          date: today,
          streakDay: 0,
        ),
        Checkin(
          id: 'c-2',
          habitId: 'h-1',
          userId: 'uid-1',
          date: today.subtract(const Duration(days: 1)),
          streakDay: 1,
        ),
      ];
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: HabitDetailScreen(habit: habit, user: user),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('2'), findsWidgets);
    });

    testWidgets('이번 달 달성률 표시', (tester) async {
      final mockRepo = MockHabitRepository();
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: HabitDetailScreen(habit: habit, user: user),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('%'), findsOneWidget);
    });
  });
}
