import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/entities/mission.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';

const _defaultMissions = [
  Mission(
    id: 'mission-first-checkin',
    title: '첫 습관 완료',
    description: '처음으로 습관을 완료하세요',
    isCompleted: false,
    rewardItemId: 'item-carrot-hat',
  ),
  Mission(
    id: 'mission-7day-streak',
    title: '7일 연속 달성',
    description: '7일 연속으로 습관을 완료하세요',
    isCompleted: false,
    rewardItemId: 'item-golden-carrot',
  ),
  Mission(
    id: 'mission-30day-streak',
    title: '첫 30일 달성',
    description: '30일 연속으로 습관을 완료하세요',
    isCompleted: false,
    rewardItemId: 'item-burrow-wallpaper',
  ),
  Mission(
    id: 'mission-3habits',
    title: '습관 3개 추가',
    description: '3개의 습관을 등록하세요',
    isCompleted: false,
    rewardItemId: 'item-flower-pot',
  ),
  Mission(
    id: 'mission-100-checkins',
    title: '체크인 100회',
    description: '총 100번 습관을 완료하세요',
    isCompleted: false,
    rewardItemId: 'item-rainbow-trail',
  ),
];

class HiveMissionRepository implements MissionRepository {
  final Box _box;

  static const _completedKey = 'completed_mission_ids';

  HiveMissionRepository(this._box);

  Set<String> get _completedIds =>
      Set<String>.from((_box.get(_completedKey) as List?)?.cast<String>() ?? []);

  @override
  Future<List<Mission>> getMissions() async {
    final completed = _completedIds;
    return _defaultMissions
        .map((m) => m.copyWith(isCompleted: completed.contains(m.id)))
        .toList();
  }

  @override
  Future<void> completeMission({required String missionId}) async {
    final mission = _defaultMissions.cast<Mission?>().firstWhere(
          (m) => m!.id == missionId,
          orElse: () => null,
        );
    if (mission == null) throw Exception('미션을 찾을 수 없습니다');

    final completed = _completedIds;
    if (completed.contains(missionId)) throw Exception('이미 완료된 미션입니다');

    completed.add(missionId);
    await _box.put(_completedKey, completed.toList());
  }
}
