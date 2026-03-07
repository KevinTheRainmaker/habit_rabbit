import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository mockRepo;

  setUp(() {
    mockRepo = MockHabitRepository();
    registerFallbackValue(Habit(
      id: 'h-1', userId: 'uid-1', name: '운동',
      createdAt: DateTime(2026, 3, 7), isActive: true,
    ));
  });

  group('HabitListNotifier', () {
    test('초기 로드 시 repository.getHabits 호출', () async {
      when(() => mockRepo.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(habitListNotifierProvider('uid-1').future);

      verify(() => mockRepo.getHabits(userId: 'uid-1')).called(1);
    });

    test('addHabit: 목록에 새 습관 추가', () async {
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      when(() => mockRepo.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => []);
      when(() => mockRepo.addHabit(any())).thenAnswer((_) async => habit);

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(habitListNotifierProvider('uid-1').future);
      await container.read(habitListNotifierProvider('uid-1').notifier)
          .addHabit(name: '운동', userId: 'uid-1');

      final habits = await container.read(habitListNotifierProvider('uid-1').future);
      expect(habits.length, equals(1));
      expect(habits.first.name, equals('운동'));
    });

    test('updateHabit: 습관 이름 수정', () async {
      final original = Habit(
        id: 'h-1', userId: 'uid-1', name: '운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      final updated = Habit(
        id: 'h-1', userId: 'uid-1', name: '매일 독서',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      when(() => mockRepo.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [original]);
      when(() => mockRepo.updateHabit(any())).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(habitListNotifierProvider('uid-1').future);
      await container.read(habitListNotifierProvider('uid-1').notifier)
          .updateHabit(updated);

      final habits = await container.read(habitListNotifierProvider('uid-1').future);
      expect(habits.length, equals(1));
      expect(habits.first.name, equals('매일 독서'));
    });

    test('deleteHabit: 목록에서 습관 제거', () async {
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      when(() => mockRepo.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => [habit]);
      when(() => mockRepo.deleteHabit(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      await container.read(habitListNotifierProvider('uid-1').future);
      await container.read(habitListNotifierProvider('uid-1').notifier)
          .deleteHabit(habitId: 'h-1', userId: 'uid-1');

      final habits = await container.read(habitListNotifierProvider('uid-1').future);
      expect(habits, isEmpty);
    });
  });
}
