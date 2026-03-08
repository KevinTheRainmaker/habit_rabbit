import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/usecases/weekly_completion_rate_usecase.dart';
import 'package:habit_rabbit/presentation/providers/checkins_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/widgets/premium_teaser_banner.dart';

class StatisticsScreen extends ConsumerWidget {
  final String userId;
  final bool isPremium;

  const StatisticsScreen({
    super.key,
    required this.userId,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListNotifierProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('전체 통계')),
      body: habitsAsync.when(
        data: (habits) {
          final allCheckins = habits.expand((habit) {
            final asyncCheckins = ref.watch(
              checkinsListProvider((habitId: habit.id, userId: userId)),
            );
            return asyncCheckins.valueOrNull ?? const <Checkin>[];
          }).cast<Checkin>().toList();

          return Column(
            children: [
              if (!isPremium)
                PremiumTeaserBanner(
                  isPremium: isPremium,
                  onUpgrade: () {},
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _StatCard(
                      label: '등록한 습관',
                      value: '${habits.length}개',
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: '총 체크인',
                      value: '${allCheckins.length}회',
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: '활성 습관',
                      value: '${habits.where((h) => h.isActive).length}개',
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: '주간 달성률',
                      value:
                          '${(WeeklyCompletionRateUseCase(checkins: allCheckins.map((c) => c.date).toList(), today: DateTime.now()).rate * 100).toStringAsFixed(0)}%',
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      label: '총 적립 당근',
                      value: '${allCheckins.fold(0, (sum, c) => sum + c.carrotPoints)}개',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
