import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/main.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/onboarding_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';
import 'package:habit_rabbit/presentation/screens/login_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  group('인증 상태 기반 라우팅', () {
    testWidgets('비로그인 상태이면 LoginScreen 표시', (tester) async {
      final mock = MockAuthRepository();
      when(() => mock.currentUser).thenAnswer((_) => Stream.value(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(mock)],
          child: const HabitRabbitApp(),
        ),
      );
      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HabitListScreen), findsNothing);
    });

    testWidgets('로그인 상태이면 HabitListScreen 표시', (tester) async {
      final mock = MockAuthRepository();
      final habitMock = MockHabitRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mock.currentUser).thenAnswer((_) => Stream.value(user));
      when(() => habitMock.getHabits(userId: 'uid-1')).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mock),
            habitRepositoryProvider.overrideWithValue(habitMock),
            onboardingCompletedProvider.overrideWith((ref) => true),
          ],
          child: const HabitRabbitApp(),
        ),
      );
      await tester.pump();

      expect(find.byType(HabitListScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}
