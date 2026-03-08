import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_mission_repository.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveMissionRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_mission_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('missions_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveMissionRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveMissionRepository', () {
    test('초기에는 모든 미션이 미완료 상태', () async {
      final missions = await repo.getMissions();
      expect(missions, isNotEmpty);
      expect(missions.every((m) => !m.isCompleted), isTrue);
    });

    test('completeMission 후 해당 미션 isCompleted=true', () async {
      final missions = await repo.getMissions();
      final mission = missions.first;

      await repo.completeMission(missionId: mission.id);
      final updated = await repo.getMissions();

      expect(updated.firstWhere((m) => m.id == mission.id).isCompleted, isTrue);
    });

    test('이미 완료된 미션 재완료 시 예외', () async {
      final missions = await repo.getMissions();
      await repo.completeMission(missionId: missions.first.id);

      expect(
        () => repo.completeMission(missionId: missions.first.id),
        throwsException,
      );
    });

    test('Box 재생성 후 완료 상태 영속', () async {
      final missions = await repo.getMissions();
      await repo.completeMission(missionId: missions.first.id);

      final repo2 = HiveMissionRepository(box);
      final updated = await repo2.getMissions();
      expect(updated.firstWhere((m) => m.id == missions.first.id).isCompleted, isTrue);
    });

    test('존재하지 않는 미션 완료 시 예외', () async {
      expect(
        () => repo.completeMission(missionId: 'nonexistent-id'),
        throwsException,
      );
    });
  });
}
