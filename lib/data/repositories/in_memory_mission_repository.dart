import 'package:habit_rabbit/domain/entities/mission.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';

class InMemoryMissionRepository implements MissionRepository {
  final List<Mission> _missions = [
    const Mission(
      id: 'mission-first-checkin',
      title: '첫 습관 완료',
      description: '처음으로 습관을 완료하세요',
      isCompleted: false,
      rewardItemId: 'item-carrot-hat',
    ),
    const Mission(
      id: 'mission-7day-streak',
      title: '7일 연속 달성',
      description: '7일 연속으로 습관을 완료하세요',
      isCompleted: false,
      rewardItemId: 'item-golden-carrot',
    ),
    const Mission(
      id: 'mission-30day-streak',
      title: '첫 30일 달성',
      description: '30일 연속으로 습관을 완료하세요',
      isCompleted: false,
      rewardItemId: 'item-burrow-wallpaper',
    ),
    const Mission(
      id: 'mission-3habits',
      title: '습관 3개 추가',
      description: '3개의 습관을 등록하세요',
      isCompleted: false,
      rewardItemId: 'item-flower-pot',
    ),
    const Mission(
      id: 'mission-100-checkins',
      title: '체크인 100회',
      description: '총 100번 습관을 완료하세요',
      isCompleted: false,
      rewardItemId: 'item-rainbow-trail',
    ),
  ];

  @override
  Future<List<Mission>> getMissions() async {
    return List.unmodifiable(_missions);
  }

  @override
  Future<void> completeMission({required String missionId}) async {
    final index = _missions.indexWhere((m) => m.id == missionId);
    if (index == -1) throw Exception('미션을 찾을 수 없습니다');
    if (_missions[index].isCompleted) throw Exception('이미 완료된 미션입니다');
    _missions[index] = _missions[index].copyWith(isCompleted: true);
  }
}
