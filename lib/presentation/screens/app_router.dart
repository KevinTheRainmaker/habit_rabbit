import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/onboarding_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';
import 'package:habit_rabbit/presentation/screens/habit_recommendation_screen.dart';
import 'package:habit_rabbit/presentation/screens/login_screen.dart';
import 'package:habit_rabbit/presentation/screens/onboarding_screen.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('오류가 발생했습니다')),
      ),
      data: (user) {
        if (user == null) {
          return LoginScreen(
            onGuestLogin: () {
              // 게스트 모드: 임시 user 생성 (InMemory auth)
              // 실제로는 authRepository.signInAsGuest() 호출
            },
          );
        }

        final onboardingCompleted = ref.watch(onboardingCompletedProvider);

        if (!onboardingCompleted) {
          return OnboardingScreen(
            onCompleted: (answers) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HabitRecommendationScreen(
                    onStart: (habits) {
                      for (final name in habits) {
                        ref
                            .read(habitListNotifierProvider(user.id).notifier)
                            .addHabit(name: name, userId: user.id);
                      }
                      ref.read(onboardingCompletedNotifierProvider.notifier).state =
                          true;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const HabitListScreen(),
                        ),
                        (_) => false,
                      );
                    },
                  ),
                ),
              );
            },
            onSkip: () {
              ref.read(onboardingCompletedNotifierProvider.notifier).state =
                  true;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const HabitListScreen(),
                ),
                (_) => false,
              );
            },
          );
        }

        return const HabitListScreen();
      },
    );
  }
}
