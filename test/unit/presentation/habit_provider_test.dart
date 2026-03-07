import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  group('habitListProvider', () {
    test('습관 목록을 HabitRepository에서 로드한다', () async {
      final mock = MockHabitRepository();
      final habits = [
        Habit(
          id: 'h-1',
          userId: 'uid-1',
          name: '운동',
          createdAt: DateTime(2026, 3, 7),
          isActive: true,
        ),
      ];
      when(() => mock.getHabits(userId: 'uid-1')).thenAnswer((_) async => habits);

      final container = ProviderContainer(
        overrides: [
          habitRepositoryProvider.overrideWithValue(mock),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(habitListProvider('uid-1').future);

      expect(result.length, equals(1));
      expect(result.first.name, equals('운동'));
    });

    test('빈 userId이면 빈 목록 반환', () async {
      final mock = MockHabitRepository();
      when(() => mock.getHabits(userId: '')).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          habitRepositoryProvider.overrideWithValue(mock),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(habitListProvider('').future);

      expect(result, isEmpty);
    });
  });
}
