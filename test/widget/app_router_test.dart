import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/onboarding_provider.dart';
import 'package:habit_rabbit/presentation/screens/app_router.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';
import 'package:habit_rabbit/presentation/screens/login_screen.dart';
import 'package:habit_rabbit/presentation/screens/onboarding_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  group('AppRouter', () {
    testWidgets('비로그인 상태에서 LoginScreen 표시', (tester) async {
      final mockAuth = MockAuthRepository();
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuth),
          ],
          child: const MaterialApp(home: AppRouter()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('로그인 + 온보딩 미완료 시 OnboardingScreen 표시', (tester) async {
      final mockAuth = MockAuthRepository();
      final mockHabit = MockHabitRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuth),
            habitRepositoryProvider.overrideWithValue(mockHabit),
            onboardingCompletedProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(home: AppRouter()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('로그인 + 온보딩 완료 시 HabitListScreen 표시', (tester) async {
      final mockAuth = MockAuthRepository();
      final mockHabit = MockHabitRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mockAuth.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => mockHabit.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuth),
            habitRepositoryProvider.overrideWithValue(mockHabit),
            onboardingCompletedProvider.overrideWith((ref) => true),
          ],
          child: const MaterialApp(home: AppRouter()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HabitListScreen), findsOneWidget);
    });
  });
}
