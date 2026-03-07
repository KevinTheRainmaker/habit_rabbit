import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/usecases/update_habit_usecase.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late UpdateHabitUseCase useCase;
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    useCase = UpdateHabitUseCase(repository);
    registerFallbackValue(Habit(
      id: 'h-1',
      userId: 'uid-1',
      name: '운동',
      createdAt: DateTime(2026, 3, 7),
      isActive: true,
    ));
  });

  group('UpdateHabitUseCase', () {
    test('습관 수정 시 repository.updateHabit 호출', () async {
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '독서',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      when(() => repository.updateHabit(any())).thenAnswer((_) async {});

      await useCase(habit);

      verify(() => repository.updateHabit(habit)).called(1);
    });

    test('isActive false로 비활성화 가능', () async {
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: false,
      );
      when(() => repository.updateHabit(any())).thenAnswer((_) async {});

      await useCase(habit);

      verify(() => repository.updateHabit(habit)).called(1);
    });
  });
}
