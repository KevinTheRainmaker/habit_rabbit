# Habit Rabbit MVP Data Layer — Implementation Plan

**Goal:** Firebase 설정 전 구현 가능한 레이어부터 TDD로 완성

- SubscriptionRepository 인터페이스 (도메인)
- Riverpod Provider 뼈대 (mock 구현체 사용)
- Firebase 활성화 후: FirebaseAuthRepository, FirestoreHabitRepository

**현황:** Firebase/RevenueCat 패키지가 pubspec.yaml에서 주석 처리됨 (외부 설정 필요)

**TDD 철칙:** 테스트 먼저 → 실패 확인 → 최소 코드 → 통과 확인

---

## Task 8: SubscriptionRepository 인터페이스 (TDD)

**Files:**

- Create: `lib/domain/repositories/subscription_repository.dart`
- Create: `test/unit/domain/subscription_repository_test.dart`

**Step 1: 실패하는 테스트 작성**

`test/unit/domain/subscription_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/subscription_repository.dart';

class MockSubscriptionRepository extends Mock implements SubscriptionRepository {}

void main() {
  late MockSubscriptionRepository repository;

  setUp(() {
    repository = MockSubscriptionRepository();
  });

  group('SubscriptionRepository', () {
    test('isPremium: 구독 상태 반환', () async {
      when(() => repository.isPremium()).thenAnswer((_) async => false);

      final result = await repository.isPremium();

      expect(result, isFalse);
    });

    test('purchasePremium: 성공 시 true 반환', () async {
      when(() => repository.purchasePremium()).thenAnswer((_) async => true);

      final result = await repository.purchasePremium();

      expect(result, isTrue);
    });

    test('restorePurchases: 복원 후 상태 반환', () async {
      when(() => repository.restorePurchases()).thenAnswer((_) async => true);

      final result = await repository.restorePurchases();

      expect(result, isTrue);
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/domain/subscription_repository_test.dart
```

Expected: FAIL — 파일 없음

**Step 3: 최소 구현**

`lib/domain/repositories/subscription_repository.dart`:

```dart
abstract class SubscriptionRepository {
  Future<bool> isPremium();
  Future<bool> purchasePremium();
  Future<bool> restorePurchases();
}
```

**Step 4: 테스트 실행 → 통과 확인**

```bash
flutter test test/unit/domain/subscription_repository_test.dart
```

Expected: PASS (3/3)

**Step 5: 커밋**

```bash
git add lib/domain/repositories/subscription_repository.dart test/unit/domain/subscription_repository_test.dart
git commit -m "feat: add SubscriptionRepository interface"
```

---

## Task 9: InMemoryHabitRepository (오프라인 구현체, TDD)

Firebase 없이 동작하는 인메모리 구현체. 개발/테스트 환경에서 사용.

**Files:**

- Create: `lib/data/repositories/in_memory_habit_repository.dart`
- Create: `test/unit/data/in_memory_habit_repository_test.dart`

**Step 1: 실패하는 테스트 작성**

`test/unit/data/in_memory_habit_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

void main() {
  late InMemoryHabitRepository repository;

  setUp(() {
    repository = InMemoryHabitRepository();
  });

  group('InMemoryHabitRepository', () {
    test('처음에는 습관 목록이 비어 있다', () async {
      final habits = await repository.getHabits(userId: 'uid-1');
      expect(habits, isEmpty);
    });

    test('addHabit: 추가 후 목록에 포함된다', () async {
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );

      await repository.addHabit(habit);
      final habits = await repository.getHabits(userId: 'uid-1');

      expect(habits.length, equals(1));
      expect(habits.first.name, equals('운동'));
    });

    test('getHabits: 다른 userId의 습관은 반환하지 않는다', () async {
      final habit = Habit(
        id: 'h-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      await repository.addHabit(habit);

      final habits = await repository.getHabits(userId: 'uid-2');

      expect(habits, isEmpty);
    });

    test('checkIn: 체크인 후 Checkin 반환 (기본 10포인트)', () async {
      final checkin = await repository.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(checkin.habitId, equals('h-1'));
      expect(checkin.carrotPoints, equals(10));
    });

    test('checkIn: 같은 날 중복 체크인 시 예외 발생', () async {
      await repository.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(
        () => repository.checkIn(
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 7),
        ),
        throwsException,
      );
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/data/in_memory_habit_repository_test.dart
```

**Step 3: 최소 구현**

`lib/data/repositories/in_memory_habit_repository.dart`

**Step 4: 테스트 실행 → 통과 확인**

**Step 5: 커밋**

```bash
git add lib/data/repositories/in_memory_habit_repository.dart test/unit/data/in_memory_habit_repository_test.dart
git commit -m "feat: add InMemoryHabitRepository for offline/dev use"
```

---

## Task 10: Riverpod Provider 뼈대 (TDD)

**Files:**

- Create: `lib/presentation/providers/habit_provider.dart`
- Create: `test/unit/presentation/habit_provider_test.dart`

**Step 1: 실패하는 테스트 작성**

```dart
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
        Habit(id: 'h-1', userId: 'uid-1', name: '운동',
            createdAt: DateTime(2026, 3, 7), isActive: true),
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
  });
}
```

**Step 2~5:** TDD 사이클 실행 후 커밋.

```bash
git commit -m "feat: add Riverpod habit provider"
```

---

## Task 11: 전체 단위 테스트 통과 확인

```bash
flutter test test/unit/
```

Expected: 모든 테스트 PASS

```bash
git commit -m "chore: data layer phase 1 complete (Firebase-independent)"
```

---

## 다음 계획 (Firebase 설정 후)

`flutterfire configure` 실행 후:

- FirebaseAuthRepository (Task 8-Firebase)
- FirestoreHabitRepository (Task 9-Firebase)
- RevenueCatSubscriptionRepository (Task 10-Firebase)
