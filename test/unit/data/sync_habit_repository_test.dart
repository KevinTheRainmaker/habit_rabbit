import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/data/repositories/sync_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository local;
  late MockHabitRepository remote;
  late SyncHabitRepository repo;

  final testHabit = Habit(
    id: 'h1',
    userId: 'u1',
    name: '운동',
    createdAt: DateTime(2026, 3, 10),
    isActive: true,
  );

  final testCheckin = Checkin(
    id: 'c1',
    habitId: 'h1',
    userId: 'u1',
    date: DateTime(2026, 3, 10),
    streakDay: 0,
  );

  setUp(() {
    local = MockHabitRepository();
    remote = MockHabitRepository();
    repo = SyncHabitRepository(local: local, remote: remote);
  });

  group('addHabit', () {
    test('로컬에 저장 후 결과 반환, 리모트는 fire-and-forget', () async {
      when(() => local.addHabit(testHabit)).thenAnswer((_) async => testHabit);
      when(() => remote.addHabit(testHabit)).thenAnswer((_) async => testHabit);

      final result = await repo.addHabit(testHabit);

      expect(result, testHabit);
      verify(() => local.addHabit(testHabit)).called(1);
      // remote는 비동기 fire-and-forget이므로 잠시 대기
      await Future.delayed(Duration.zero);
      verify(() => remote.addHabit(testHabit)).called(1);
    });

    test('리모트 실패해도 로컬 결과 반환', () async {
      when(() => local.addHabit(testHabit)).thenAnswer((_) async => testHabit);
      when(() => remote.addHabit(testHabit)).thenThrow(Exception('network error'));

      final result = await repo.addHabit(testHabit);
      expect(result, testHabit);
    });
  });

  group('updateHabit', () {
    test('로컬 업데이트 후 리모트 fire-and-forget', () async {
      when(() => local.updateHabit(testHabit)).thenAnswer((_) async {});
      when(() => remote.updateHabit(testHabit)).thenAnswer((_) async {});

      await repo.updateHabit(testHabit);

      verify(() => local.updateHabit(testHabit)).called(1);
      await Future.delayed(Duration.zero);
      verify(() => remote.updateHabit(testHabit)).called(1);
    });
  });

  group('deleteHabit', () {
    test('로컬 삭제 후 리모트 fire-and-forget', () async {
      when(() => local.deleteHabit(habitId: 'h1', userId: 'u1'))
          .thenAnswer((_) async {});
      when(() => remote.deleteHabit(habitId: 'h1', userId: 'u1'))
          .thenAnswer((_) async {});

      await repo.deleteHabit(habitId: 'h1', userId: 'u1');

      verify(() => local.deleteHabit(habitId: 'h1', userId: 'u1')).called(1);
      await Future.delayed(Duration.zero);
      verify(() => remote.deleteHabit(habitId: 'h1', userId: 'u1')).called(1);
    });
  });

  group('checkIn', () {
    test('로컬 체크인 후 리모트 fire-and-forget', () async {
      when(() => local.checkIn(
        habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 10),
      )).thenAnswer((_) async => testCheckin);
      when(() => remote.checkIn(
        habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 10),
      )).thenAnswer((_) async => testCheckin);

      final result = await repo.checkIn(
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 10),
      );

      expect(result, testCheckin);
      verify(() => local.checkIn(
        habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 10),
      )).called(1);
    });
  });

  group('getHabits', () {
    test('로컬에서 습관 목록 반환', () async {
      when(() => local.getHabits(userId: 'u1'))
          .thenAnswer((_) async => [testHabit]);

      final habits = await repo.getHabits(userId: 'u1');
      expect(habits, [testHabit]);
      verifyNever(() => remote.getHabits(userId: any(named: 'userId')));
    });
  });

  group('getCheckins', () {
    test('로컬에서 체크인 목록 반환', () async {
      when(() => local.getCheckins(habitId: 'h1', userId: 'u1'))
          .thenAnswer((_) async => [testCheckin]);

      final checkins = await repo.getCheckins(habitId: 'h1', userId: 'u1');
      expect(checkins, [testCheckin]);
      verifyNever(() => remote.getCheckins(
        habitId: any(named: 'habitId'), userId: any(named: 'userId'),
      ));
    });
  });

  group('syncFromRemote', () {
    test('리모트 habits을 로컬에 upsert', () async {
      final remoteHabit = Habit(
        id: 'h2',
        userId: 'u1',
        name: '독서',
        createdAt: DateTime(2026, 3, 10),
        isActive: true,
      );
      when(() => remote.getHabits(userId: 'u1'))
          .thenAnswer((_) async => [remoteHabit]);
      when(() => local.addHabit(remoteHabit))
          .thenAnswer((_) async => remoteHabit);

      await repo.syncFromRemote(userId: 'u1');

      verify(() => local.addHabit(remoteHabit)).called(1);
    });

    test('리모트 실패 시 무시 (오프라인 허용)', () async {
      when(() => remote.getHabits(userId: 'u1'))
          .thenThrow(Exception('network error'));

      // 예외 없이 완료
      await expectLater(repo.syncFromRemote(userId: 'u1'), completes);
    });
  });
}
