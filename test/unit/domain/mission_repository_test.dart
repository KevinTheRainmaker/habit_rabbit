import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_mission_repository.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';

void main() {
  group('InMemoryMissionRepository', () {
    test('MissionRepository를 구현한다', () {
      expect(InMemoryMissionRepository(), isA<MissionRepository>());
    });

    test('5개 기본 미션 반환', () async {
      final repo = InMemoryMissionRepository();
      final missions = await repo.getMissions();
      expect(missions.length, equals(5));
    });

    test('completeMission 후 isCompleted=true', () async {
      final repo = InMemoryMissionRepository();
      final missions = await repo.getMissions();
      final firstId = missions.first.id;
      await repo.completeMission(missionId: firstId);
      final updated = await repo.getMissions();
      expect(updated.first.isCompleted, isTrue);
    });

    test('이미 완료된 미션 재완료 시 예외', () async {
      final repo = InMemoryMissionRepository();
      final missions = await repo.getMissions();
      final firstId = missions.first.id;
      await repo.completeMission(missionId: firstId);
      expect(
        () => repo.completeMission(missionId: firstId),
        throwsException,
      );
    });
  });
}
