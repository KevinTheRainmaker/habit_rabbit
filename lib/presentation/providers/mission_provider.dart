import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/repositories/in_memory_mission_repository.dart';
import 'package:habit_rabbit/domain/entities/mission.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';

final missionRepositoryProvider = Provider<MissionRepository>(
  (ref) => InMemoryMissionRepository(),
);

final missionsProvider = FutureProvider<List<Mission>>((ref) async {
  return ref.watch(missionRepositoryProvider).getMissions();
});
