# Habit Rabbit MVP Use Cases — Implementation Plan

**Goal:** 도메인 유스케이스 TDD 구현 (순수 Dart, Firebase 불필요)

**Use cases:** 비즈니스 로직을 Repository와 분리. 각 유스케이스는 단일 책임.

---

## Task 12: AddHabitUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/add_habit_usecase.dart`
- Create: `test/unit/domain/add_habit_usecase_test.dart`

**Step 1: 실패하는 테스트**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/domain/usecases/add_habit_usecase.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late AddHabitUseCase useCase;
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    useCase = AddHabitUseCase(repository);
    registerFallbackValue(Habit(
      id: 'h-1', userId: 'uid-1', name: '운동',
      createdAt: DateTime(2026, 3, 7), isActive: true,
    ));
  });

  group('AddHabitUseCase', () {
    test('습관을 추가하면 저장된 Habit 반환', () async {
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      when(() => repository.addHabit(any())).thenAnswer((_) async => habit);

      final result = await useCase(habit);

      expect(result.name, equals('운동'));
      verify(() => repository.addHabit(habit)).called(1);
    });

    test('무료 사용자가 3개 초과 습관 추가 시 예외', () async {
      final existing = [
        Habit(id: 'h-1', userId: 'uid-1', name: 'A', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-2', userId: 'uid-1', name: 'B', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-3', userId: 'uid-1', name: 'C', createdAt: DateTime(2026, 3, 7), isActive: true),
      ];
      when(() => repository.getHabits(userId: 'uid-1')).thenAnswer((_) async => existing);

      final newHabit = Habit(
        id: 'h-4', userId: 'uid-1', name: 'D',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );

      expect(
        () => useCase(newHabit, isPremium: false),
        throwsException,
      );
    });

    test('프리미엄 사용자는 3개 초과 습관 추가 가능', () async {
      final existing = [
        Habit(id: 'h-1', userId: 'uid-1', name: 'A', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-2', userId: 'uid-1', name: 'B', createdAt: DateTime(2026, 3, 7), isActive: true),
        Habit(id: 'h-3', userId: 'uid-1', name: 'C', createdAt: DateTime(2026, 3, 7), isActive: true),
      ];
      when(() => repository.getHabits(userId: 'uid-1')).thenAnswer((_) async => existing);
      final newHabit = Habit(
        id: 'h-4', userId: 'uid-1', name: 'D',
        createdAt: DateTime(2026, 3, 7), isActive: true,
      );
      when(() => repository.addHabit(any())).thenAnswer((_) async => newHabit);

      final result = await useCase(newHabit, isPremium: true);

      expect(result.name, equals('D'));
    });
  });
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: add AddHabitUseCase with free tier limit"
```

---

## Task 13: CheckInUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/checkin_usecase.dart`
- Create: `test/unit/domain/checkin_usecase_test.dart`

**비즈니스 규칙:**

- 체크인 후 당근 포인트 반환
- 중복 체크인은 repository에서 예외

**Step 5: 커밋**

```bash
git commit -m "feat: add CheckInUseCase"
```

---

## Task 14: GetHabitsUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/get_habits_usecase.dart`
- Create: `test/unit/domain/get_habits_usecase_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add GetHabitsUseCase"
```

---

## Task 15: 전체 테스트 통과 확인

```bash
flutter test test/unit/
```

```bash
git commit -m "chore: use case layer complete"
```
