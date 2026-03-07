import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/presentation/providers/checkin_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  group('checkInProvider', () {
    test('체크인 성공 시 Checkin 반환', () async {
      final mock = MockHabitRepository();
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );
      when(() => mock.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
          )).thenAnswer((_) async => checkin);

      final container = ProviderContainer(
        overrides: [habitRepositoryProvider.overrideWithValue(mock)],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        checkInProvider((
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 7),
        )).future,
      );

      expect(result.carrotPoints, equals(10));
    });
  });
}
