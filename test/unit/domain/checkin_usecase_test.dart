import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/usecases/checkin_usecase.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late CheckInUseCase useCase;
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    useCase = CheckInUseCase(repository);
  });

  group('CheckInUseCase', () {
    test('체크인 성공 시 Checkin 반환 (기본 10포인트)', () async {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );
      when(() => repository.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
          )).thenAnswer((_) async => checkin);

      final result = await useCase(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(result.carrotPoints, equals(10));
      expect(result.habitId, equals('h-1'));
    });

    test('7일 스트릭 체크인 시 15포인트', () async {
      final checkin = Checkin(
        id: 'c-7',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 13),
        streakDay: 6,
      );
      when(() => repository.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 13),
          )).thenAnswer((_) async => checkin);

      final result = await useCase(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 13),
      );

      expect(result.carrotPoints, equals(15));
    });

    test('repository가 예외 던지면 useCase도 예외 전파', () async {
      when(() => repository.checkIn(
            habitId: 'h-1',
            userId: 'uid-1',
            date: DateTime(2026, 3, 7),
          )).thenThrow(Exception('중복 체크인'));

      expect(
        () => useCase(
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 7),
        ),
        throwsException,
      );
    });
  });
}
