import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/usecases/all_time_streak_usecase.dart';
import 'package:habit_rabbit/domain/usecases/get_checkins_usecase.dart';
import 'package:habit_rabbit/domain/usecases/monthly_completion_rate_usecase.dart';
import 'package:habit_rabbit/presentation/providers/checkins_provider.dart';
import 'package:habit_rabbit/presentation/providers/date_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit;
  final User user;

  const HabitDetailScreen({super.key, required this.habit, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkinsAsync = ref.watch(
      checkinsListProvider((habitId: habit.id, userId: user.id)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: checkinsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (checkins) {
          final repository = ref.read(habitRepositoryProvider);
          final today = ref.watch(currentDateProvider);
          final useCase = GetCheckinsUseCase(repository);
          final rateUseCase = MonthlyCompletionRateUseCase();
          final allTimeStreakUseCase = AllTimeStreakUseCase();

          final allTimeStreak = allTimeStreakUseCase.call(checkins: checkins);
          final rate = rateUseCase.call(checkins: checkins, today: today);

          return FutureBuilder<int>(
            future: useCase.currentStreak(
              habitId: habit.id,
              userId: user.id,
              today: today,
            ),
            builder: (context, streakSnapshot) {
              final streak = streakSnapshot.data ?? 0;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.local_fire_department),
                        title: const Text('현재 스트릭'),
                        trailing: Text(
                          '$streak일',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.emoji_events),
                        title: const Text('역대 최장'),
                        trailing: Text(
                          '$allTimeStreak일',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.bar_chart),
                        title: const Text('이번 달 달성률'),
                        trailing: Text(
                          '${(rate * 100).round()}%',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
