import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/usecases/delete_habit_usecase.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late DeleteHabitUseCase useCase;
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    useCase = DeleteHabitUseCase(repository);
  });

  group('DeleteHabitUseCase', () {
    test('습관 삭제 시 repository.deleteHabit 호출', () async {
      when(() => repository.deleteHabit(habitId: 'h-1', userId: 'uid-1'))
          .thenAnswer((_) async {});

      await useCase(habitId: 'h-1', userId: 'uid-1');

      verify(() => repository.deleteHabit(habitId: 'h-1', userId: 'uid-1')).called(1);
    });

    test('repository 예외 시 예외 전파', () async {
      when(() => repository.deleteHabit(habitId: 'h-1', userId: 'uid-1'))
          .thenThrow(Exception('삭제 실패'));

      expect(
        () => useCase(habitId: 'h-1', userId: 'uid-1'),
        throwsException,
      );
    });
  });
}
