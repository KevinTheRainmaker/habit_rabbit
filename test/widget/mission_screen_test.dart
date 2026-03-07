import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/mission.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';
import 'package:habit_rabbit/presentation/screens/mission_screen.dart';

class _FakeMissionRepository implements MissionRepository {
  final List<Mission> missions;
  _FakeMissionRepository(this.missions);

  @override
  Future<List<Mission>> getMissions() async => missions;

  @override
  Future<void> completeMission({required String missionId}) async {}
}

Widget buildScreen(List<Mission> missions) {
  return ProviderScope(
    overrides: [
      missionRepositoryProvider.overrideWithValue(
        _FakeMissionRepository(missions),
      ),
    ],
    child: const MaterialApp(home: MissionScreen()),
  );
}

void main() {
  group('MissionScreen', () {
    testWidgets('미션 목록 표시', (tester) async {
      final missions = [
        const Mission(
          id: 'm-1',
          title: '첫 습관 완료',
          description: '처음으로 습관을 완료하세요',
          isCompleted: false,
          rewardItemId: 'item-1',
        ),
      ];
      await tester.pumpWidget(buildScreen(missions));
      await tester.pump();
      expect(find.text('첫 습관 완료'), findsOneWidget);
    });

    testWidgets('완료된 미션에 체크 표시', (tester) async {
      final missions = [
        const Mission(
          id: 'm-1',
          title: '첫 습관 완료',
          description: '처음으로 습관을 완료하세요',
          isCompleted: true,
          rewardItemId: 'item-1',
        ),
      ];
      await tester.pumpWidget(buildScreen(missions));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('미완료 미션에 진행 상태 표시', (tester) async {
      final missions = [
        const Mission(
          id: 'm-1',
          title: '첫 습관 완료',
          description: '처음으로 습관을 완료하세요',
          isCompleted: false,
          rewardItemId: 'item-1',
        ),
      ];
      await tester.pumpWidget(buildScreen(missions));
      await tester.pump();
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    });
  });
}
