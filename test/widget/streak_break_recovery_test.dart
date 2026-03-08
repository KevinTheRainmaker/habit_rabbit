import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/recovery_ticket.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/repositories/recovery_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/recovery_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';

class MockHabitRepository extends Mock implements HabitRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockRecoveryRepository extends Mock implements RecoveryRepository {}

Widget buildApp({
  required MockHabitRepository mockHabit,
  required MockAuthRepository mockAuth,
  required MockRecoveryRepository mockRecovery,
}) {
  return ProviderScope(
    overrides: [
      habitRepositoryProvider.overrideWithValue(mockHabit),
      authRepositoryProvider.overrideWithValue(mockAuth),
      recoveryRepositoryProvider.overrideWithValue(mockRecovery),
    ],
    child: const MaterialApp(home: HabitListScreen()),
  );
}

void main() {
  group('HabitListScreen - RecoveryRepository 연결', () {
    late MockHabitRepository mockHabit;
    late MockAuthRepository mockAuth;
    late MockRecoveryRepository mockRecovery;

    setUp(() {
      mockHabit = MockHabitRepository();
      mockAuth = MockAuthRepository();
      mockRecovery = MockRecoveryRepository();
    });

    void setupStreakBroken() {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      final today = DateTime.now();
      final twoDaysAgo = today.subtract(const Duration(days: 2));
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
          date: twoDaysAgo,
          streakDay: 1,
        ),
      ];
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockHabit.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);
    }

    testWidgets('freeTrialUsed=true이면 복구권 버튼 비활성화', (tester) async {
      setupStreakBroken();
      when(() => mockRecovery.getTicket(userId: 'uid-1')).thenAnswer(
        (_) async =>
            const RecoveryTicket(count: 0, freeTrialUsed: true),
      );

      await tester.pumpWidget(buildApp(
        mockHabit: mockHabit,
        mockAuth: mockAuth,
        mockRecovery: mockRecovery,
      ));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('무료 복구권 사용하기'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('freeTrialUsed=false이면 복구권 버튼 활성화', (tester) async {
      setupStreakBroken();
      when(() => mockRecovery.getTicket(userId: 'uid-1')).thenAnswer(
        (_) async =>
            const RecoveryTicket(count: 0, freeTrialUsed: false),
      );
      when(() => mockRecovery.useFreeTrial(userId: 'uid-1'))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildApp(
        mockHabit: mockHabit,
        mockAuth: mockAuth,
        mockRecovery: mockRecovery,
      ));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('무료 복구권 사용하기'),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}
