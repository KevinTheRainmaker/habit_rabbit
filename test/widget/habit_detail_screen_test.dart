import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/date_provider.dart';
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

    testWidgets('최장 스트릭 표시', (tester) async {
      final mockRepo = MockHabitRepository();
      // 1~5일 연속 체크인 → 최장 5일
      final checkins = List.generate(5, (i) => Checkin(
        id: 'c-$i',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, i + 1),
        streakDay: i,
      ));
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

      expect(find.textContaining('역대 최장'), findsOneWidget);
      expect(find.textContaining('5일'), findsWidgets);
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

    // RED: HabitDetailScreen이 currentDateProvider 날짜로 달성률 계산
    testWidgets('HabitDetailScreen이 currentDateProvider 날짜를 사용함', (tester) async {
      final mockRepo = MockHabitRepository();
      final futureDate = DateTime(9999, 1, 1);
      // futureDate 날짜에 체크인
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => [
                Checkin(
                  id: 'c-1',
                  habitId: 'h-1',
                  userId: 'uid-1',
                  date: futureDate,
                  streakDay: 0,
                ),
              ]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockRepo),
            currentDateProvider.overrideWith((ref) => futureDate),
          ],
          child: MaterialApp(
            home: HabitDetailScreen(habit: habit, user: user),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // currentDateProvider 날짜로 달성률이 100% (체크인 1개/1개)
      expect(find.textContaining('100%'), findsOneWidget);
    });
  });
}
