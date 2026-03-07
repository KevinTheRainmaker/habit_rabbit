import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';

class MockHabitRepository extends Mock implements HabitRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('HabitListScreen', () {
    testWidgets('앱바에 "내 습관" 타이틀 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(null));
      when(() => mockHabit.getHabits(userId: any(named: 'userId')))
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
      await tester.pump();

      expect(find.text('내 습관'), findsOneWidget);
    });

    testWidgets('습관 목록이 있으면 이름 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);

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

      expect(find.text('매일 운동'), findsOneWidget);
    });

    testWidgets('습관이 없으면 빈 상태 메시지 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
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

      expect(find.text('습관을 추가해보세요!'), findsOneWidget);
    });

    testWidgets('FAB 존재', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
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

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('습관 타일 스와이프로 삭제', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.deleteHabit(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async {});

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

      await tester.drag(find.text('매일 운동'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('매일 운동'), findsNothing);
    });

    testWidgets('습관 타일 탭 시 당근 포인트 표시', (tester) async {
      final mockHabit = MockHabitRepository();
      final mockAuth = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1')).thenAnswer((_) async => [
            Habit(
              id: 'h-1',
              userId: 'uid-1',
              name: '매일 운동',
              createdAt: DateTime(2026, 3, 7),
              isActive: true,
            ),
          ]);
      when(() => mockHabit.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: any(named: 'date'),
          )).thenAnswer((_) async => Checkin(
            id: 'c-1',
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
            streakDay: 0,
          ));

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

      await tester.tap(find.text('매일 운동'));
      await tester.pumpAndSettle();

      expect(find.textContaining('+10 획득'), findsOneWidget);
    });
  });
}
