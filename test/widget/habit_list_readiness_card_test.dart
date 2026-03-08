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
import 'package:habit_rabbit/presentation/widgets/habit_readiness_card.dart';

class MockHabitRepository extends Mock implements HabitRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('HabitListScreen - HabitReadinessCard', () {
    testWidgets('달성률 80% 이상이고 습관 3개 미만이면 HabitReadinessCard 표시',
        (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final today = DateTime.now();
      // 오늘 포함 7일 모두 체크인 → 달성률 100%
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

      expect(find.byType(HabitReadinessCard), findsOneWidget);
    });

    testWidgets('달성률 80% 미만이면 HabitReadinessCard 미표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      // 체크인 없음 → 달성률 0%
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
          .thenAnswer((_) async => []);

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

      expect(find.byType(HabitReadinessCard), findsNothing);
    });
  });
}
