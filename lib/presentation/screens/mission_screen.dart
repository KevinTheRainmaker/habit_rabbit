import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';

class MissionScreen extends ConsumerWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(missionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('미션')),
      body: missionsAsync.when(
        data: (missions) => ListView.builder(
          itemCount: missions.length,
          itemBuilder: (context, index) {
            final mission = missions[index];
            return ListTile(
              leading: Icon(
                mission.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: mission.isCompleted ? Colors.green : null,
              ),
              title: Text(mission.title),
              subtitle: Text(mission.description),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
