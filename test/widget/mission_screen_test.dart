import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/mission.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/repositories/mission_repository.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';
import 'package:habit_rabbit/presentation/screens/mission_screen.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

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

    testWidgets('userId 제공 시 체크인 기반으로 첫 체크인 미션 자동 완료 표시', (tester) async {
      final mockRepo = MockHabitRepository();
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      final checkins = [
        Checkin(
          id: 'c-1', habitId: 'h-1', userId: 'uid-1',
          date: DateTime(2026, 3, 7), streakDay: 0,
        ),
      ];
      when(() => mockRepo.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            habitRepositoryProvider.overrideWithValue(mockRepo),
            missionRepositoryProvider.overrideWithValue(
              _FakeMissionRepository([
                const Mission(
                  id: 'mission-first-checkin',
                  title: '첫 체크인',
                  description: '처음으로 습관을 완료하세요',
                  isCompleted: false,
                  rewardItemId: 'item-1',
                ),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: MissionScreen(userId: 'uid-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 체크인 1개 → 첫 체크인 미션이 check_circle로 표시
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
