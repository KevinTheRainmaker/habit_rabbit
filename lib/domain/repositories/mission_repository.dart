import 'package:habit_rabbit/domain/entities/mission.dart';

abstract class MissionRepository {
  Future<List<Mission>> getMissions();
  Future<void> completeMission({required String missionId});
}
