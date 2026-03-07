import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/usecases/get_checkins_usecase.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late GetCheckinsUseCase useCase;
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    useCase = GetCheckinsUseCase(repository);
  });

  group('GetCheckinsUseCase', () {
    test('habitId와 userId로 체크인 목록 반환', () async {
      final checkins = [
        Checkin(id: 'c-1', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 7), streakDay: 0),
        Checkin(id: 'c-2', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 8), streakDay: 1),
      ];
      when(() => repository.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      final result = await useCase(habitId: 'h-1', userId: 'uid-1');

      expect(result.length, equals(2));
      expect(result.first.streakDay, equals(0));
    });

    test('체크인이 없으면 빈 목록 반환', () async {
      when(() => repository.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      final result = await useCase(habitId: 'h-1', userId: 'uid-1');

      expect(result, isEmpty);
    });

    test('현재 스트릭 수 계산 — 연속 체크인 기준', () async {
      final today = DateTime(2026, 3, 10);
      final checkins = [
        Checkin(id: 'c-1', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 8), streakDay: 0),
        Checkin(id: 'c-2', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 9), streakDay: 1),
        Checkin(id: 'c-3', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 10), streakDay: 2),
      ];
      when(() => repository.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => checkins);

      final currentStreak = await useCase.currentStreak(
        habitId: 'h-1',
        userId: 'uid-1',
        today: today,
      );

      expect(currentStreak, equals(3));
    });
  });
}
