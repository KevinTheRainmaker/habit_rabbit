import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';
import 'package:habit_rabbit/presentation/screens/streak_break_dialog.dart';

class MockHabitRepository extends Mock implements HabitRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('HabitListScreen - StreakBreakDialog 통합', () {
    testWidgets('스트릭 끊김 감지 시 StreakBreakDialog 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final today = DateTime.now();
      // 어제가 아닌 이틀 전 체크인 → 스트릭 끊김
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final checkins = [
        Checkin(
          id: 'c-1',
          habitId: 'h-1',
          userId: 'uid-1',
          date: twoDaysAgo,
          streakDay: 1,
        ),
      ];
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '매일 운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StreakBreakDialog), findsOneWidget);
    });

    testWidgets('"괜찮아, 다시 시작할게" 탭 시 다이얼로그 닫힘', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final today = DateTime.now();
      final twoDaysAgo = today.subtract(const Duration(days: 2));
      final checkins = [
        Checkin(
          id: 'c-1',
          habitId: 'h-1',
          userId: 'uid-1',
          date: twoDaysAgo,
          streakDay: 1,
        ),
      ];
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '매일 운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockHabit),
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: HabitListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('괜찮아, 다시 시작할게'));
      await tester.pumpAndSettle();

      expect(find.byType(StreakBreakDialog), findsNothing);
    });
  });
}
