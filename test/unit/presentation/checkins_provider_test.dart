import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/checkins_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository mockRepo;

  setUp(() {
    mockRepo = MockHabitRepository();
  });

  group('checkinsListProvider', () {
    test('habitId와 userId로 체크인 목록 반환', () async {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => [checkin]);

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final checkins = await container.read(
        checkinsListProvider((habitId: 'h-1', userId: 'uid-1')).future,
      );

      expect(checkins.length, equals(1));
      expect(checkins.first.id, equals('c-1'));
    });

    test('체크인 없으면 빈 목록 반환', () async {
      when(() => mockRepo.getCheckins(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mockRepo)],
      );
      addTearDown(container.dispose);

      final checkins = await container.read(
        checkinsListProvider((habitId: 'h-1', userId: 'uid-1')).future,
      );

      expect(checkins, isEmpty);
    });
  });
}
