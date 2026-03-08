import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/usecases/check_mission_usecase.dart';
import 'package:habit_rabbit/presentation/providers/checkins_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';

class MissionScreen extends ConsumerWidget {
  final String? userId;

  const MissionScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(missionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('미션')),
      body: missionsAsync.when(
        data: (missions) {
          // userId가 제공된 경우 실제 체크인 기반으로 완료 여부 계산
          List<String> completedIds = [];
          if (userId != null) {
            final habitsAsync = ref.watch(habitListNotifierProvider(userId!));
            final allHabits = habitsAsync.valueOrNull ?? [];
            final allCheckins = allHabits.expand((habit) {
              final asyncCheckins = ref.watch(
                checkinsListProvider((habitId: habit.id, userId: userId!)),
              );
              return asyncCheckins.valueOrNull ?? const <Checkin>[];
            }).cast<Checkin>().toList();

            final maxStreak = allCheckins.isEmpty
                ? 0
                : allCheckins.map((c) => c.streakDay + 1).reduce((a, b) => a > b ? a : b);

            completedIds = CheckMissionUseCase(
              checkinCount: allCheckins.length,
              currentStreak: maxStreak,
              habitCount: allHabits.length,
            ).completedMissionIds;
          }

          return ListView.builder(
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final isCompleted = mission.isCompleted ||
                  completedIds.contains(mission.id);
              return ListTile(
                leading: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isCompleted ? Colors.green : null,
                ),
                title: Text(mission.title),
                subtitle: Text(mission.description),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
