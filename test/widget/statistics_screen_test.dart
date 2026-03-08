import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/statistics_screen.dart';
import 'package:habit_rabbit/presentation/widgets/premium_teaser_banner.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  group('StatisticsScreen', () {
    testWidgets('전체 통계 타이틀 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mockHabit)],
          child: const MaterialApp(
            home: StatisticsScreen(userId: 'uid-1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('전체 통계'), findsOneWidget);
    });

    testWidgets('총 체크인 수 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '매일 운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      final checkins = [
        Checkin(
          id: 'c-1',
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 7),
          streakDay: 0,
        ),
        Checkin(
          id: 'c-2',
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 6),
          streakDay: 1,
        ),
      ];
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mockHabit)],
          child: const MaterialApp(
            home: StatisticsScreen(userId: 'uid-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('2'), findsWidgets);
    });

    testWidgets('습관 수 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final habits = [
        Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-2', userId: 'uid-1', name: '독서', createdAt: DateTime(2026, 3, 7), isActive: true),
      ];
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => habits);
      for (final h in habits) {
        when(() => mockHabit.getCheckins(habitId: h.id, userId: 'uid-1'))
            .thenAnswer((_) async => []);
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mockHabit)],
          child: const MaterialApp(
            home: StatisticsScreen(userId: 'uid-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('습관'), findsWidgets);
    });

    testWidgets('무료 사용자 통계 화면에 PremiumTeaserBanner 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mockHabit)],
          child: const MaterialApp(
            home: StatisticsScreen(userId: 'uid-1', isPremium: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PremiumTeaserBanner), findsOneWidget);
    });

    testWidgets('프리미엄 사용자 통계 화면에 PremiumTeaserBanner 미표시', (tester) async {
      final mockHabit = MockHabitRepository();
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mockHabit)],
          child: const MaterialApp(
            home: StatisticsScreen(userId: 'uid-1', isPremium: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PremiumTeaserBanner), findsNothing);
    });

    testWidgets('주간 달성률 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final today = DateTime.now();
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '매일 운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      final checkins = List.generate(
        7,
        (i) => Checkin(
          id: 'c-$i',
          habitId: 'h-1',
          userId: 'uid-1',
          date: today.subtract(Duration(days: i)),
          streakDay: i,
        ),
      );
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [habitRepositoryProvider.overrideWithValue(mockHabit)],
          child: const MaterialApp(
            home: StatisticsScreen(userId: 'uid-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('주간'), findsOneWidget);
    });
  });
}
