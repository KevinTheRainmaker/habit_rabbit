import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/usecases/get_habits_usecase.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late GetHabitsUseCase useCase;
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    useCase = GetHabitsUseCase(repository);
  });

  group('GetHabitsUseCase', () {
    test('활성 습관만 반환한다', () async {
      final habits = [
        Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-2', userId: 'uid-1', name: '독서', createdAt: DateTime(2026, 3, 7), isActive: false),
      ];
      when(() => repository.getHabits(userId: 'uid-1')).thenAnswer((_) async => habits);

      final result = await useCase(userId: 'uid-1');

      expect(result.length, equals(1));
      expect(result.first.name, equals('운동'));
    });

    test('습관이 없으면 빈 목록 반환', () async {
      when(() => repository.getHabits(userId: 'uid-1')).thenAnswer((_) async => []);

      final result = await useCase(userId: 'uid-1');

      expect(result, isEmpty);
    });

    test('includeInactive: true 이면 비활성 습관도 포함', () async {
      final habits = [
        Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-2', userId: 'uid-1', name: '독서', createdAt: DateTime(2026, 3, 7), isActive: false),
      ];
      when(() => repository.getHabits(userId: 'uid-1')).thenAnswer((_) async => habits);

      final result = await useCase(userId: 'uid-1', includeInactive: true);

      expect(result.length, equals(2));
    });
  });
}
