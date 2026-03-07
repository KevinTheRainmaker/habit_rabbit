# Habit Rabbit MVP Foundation — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Flutter MVP 기반 구축 — 인증(Firebase Auth + Apple/Google Sign-In), 구독(RevenueCat), 핵심 습관 루프(체크인/스트릭/당근 포인트), 기본 UI까지 TDD로 구현

**Architecture:** Clean Architecture (Domain → Data → Presentation). 비즈니스 로직은 순수 Dart(의존성 없음)로 작성하여 단위 테스트 용이. Riverpod으로 상태 관리. Firebase는 인터페이스 뒤에 숨겨 테스트 시 Mock으로 대체.

**Tech Stack:** Flutter 3.x, Dart, Riverpod, Firebase (Auth/Firestore/Functions), RevenueCat, Hive, Mockito/Mocktail

**TDD 철칙:** 테스트 먼저 → 실패 확인 → 최소 코드 → 통과 확인 → 리팩토링. 테스트 없는 프로덕션 코드 절대 금지.

---

## 사전 요구사항 (코드 작성 전 1회 수행)

- [x] Flutter SDK 설치 확인: Flutter 3.29.2 (stable) ✅
- [ ] Firebase 프로젝트 생성 (Firebase Console) — 수동 작업 필요
- [ ] `flutterfire configure` 실행 → `google-services.json`, `GoogleService-Info.plist` 생성 — 수동 작업 필요
- [ ] RevenueCat 계정 생성 + iOS/Android App 등록 + API Key 확보 — 수동 작업 필요
- [ ] Apple Developer: Sign in with Apple capability 활성화 — 수동 작업 필요

---

## Task 0: Flutter 프로젝트 초기화 ✅

**Files:**

- Create: `pubspec.yaml`
- Create: `lib/main.dart`

**Step 1: Flutter 프로젝트 생성**

```bash
flutter create --org com.habitrabbit --project-name habit_rabbit .
```

Expected: Flutter 기본 프로젝트 파일 생성

**Step 2: pubspec.yaml 의존성 추가**

`pubspec.yaml`의 `dependencies`를 다음으로 교체:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 상태 관리
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Firebase
  firebase_core: ^3.3.0
  firebase_auth: ^5.1.4
  cloud_firestore: ^5.2.1

  # 인증
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.1

  # 구독
  purchases_flutter: ^8.0.0

  # 로컬 저장소
  hive_flutter: ^1.1.0

  # 유틸
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  equatable: ^2.0.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

  # 코드 생성
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  freezed: ^2.5.7
  json_serializable: ^6.8.0

  # 테스트
  mocktail: ^1.0.4
  fake_cloud_firestore: ^3.0.3
  firebase_auth_mocks: ^0.14.1
```

**Step 3: 패키지 설치**

```bash
flutter pub get
```

Expected: 에러 없이 완료

**Step 4: 커밋**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: initialize Flutter project with dependencies"
```

---

## Task 1: 프로젝트 디렉토리 구조 ✅

**Files:**

- Create: `lib/` 하위 디렉토리 구조

**Step 1: 디렉토리 생성**

```bash
mkdir -p lib/core/error
mkdir -p lib/core/utils
mkdir -p lib/domain/entities
mkdir -p lib/domain/repositories
mkdir -p lib/domain/usecases
mkdir -p lib/data/repositories
mkdir -p lib/data/datasources
mkdir -p lib/presentation/providers
mkdir -p lib/presentation/screens
mkdir -p lib/presentation/widgets
mkdir -p test/unit/domain
mkdir -p test/unit/data
mkdir -p test/widget
```

**Step 2: `lib/core/error/failures.dart` 생성**

```dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class SubscriptionFailure extends Failure {
  const SubscriptionFailure(super.message);
}

class HabitFailure extends Failure {
  const HabitFailure(super.message);
}
```

**Step 3: 커밋**

```bash
git add lib/ test/
git commit -m "chore: set up project directory structure"
```

---

## Task 2: User 엔티티 (TDD)

**Files:**

- Create: `lib/domain/entities/user.dart`
- Create: `test/unit/domain/user_test.dart`

**Step 1: 실패하는 테스트 작성**

`test/unit/domain/user_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/user.dart';

void main() {
  group('User entity', () {
    test('두 User가 같은 id를 가지면 동일하다', () {
      const user1 = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      const user2 = User(id: 'uid-1', email: 'other@test.com', isPremium: true);

      expect(user1, equals(user2));
    });

    test('isPremium false인 User는 프리미엄 기능 없음', () {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);

      expect(user.isPremium, isFalse);
    });

    test('isPremium true인 User는 프리미엄 기능 있음', () {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: true);

      expect(user.isPremium, isTrue);
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/domain/user_test.dart
```

Expected: FAIL — "Target of URI doesn't exist"

**Step 3: 최소 구현**

`lib/domain/entities/user.dart`:

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final bool isPremium;

  const User({
    required this.id,
    required this.email,
    required this.isPremium,
  });

  @override
  List<Object> get props => [id];
}
```

**Step 4: 테스트 실행 → 통과 확인**

```bash
flutter test test/unit/domain/user_test.dart
```

Expected: PASS (3/3)

**Step 5: 커밋**

```bash
git add lib/domain/entities/user.dart test/unit/domain/user_test.dart
git commit -m "feat: add User entity with premium flag"
```

---

## Task 3: AuthRepository 인터페이스 + 에러 타입 (TDD)

**Files:**

- Create: `lib/domain/repositories/auth_repository.dart`
- Create: `test/unit/domain/auth_repository_test.dart`

**Step 1: 인터페이스 정의 (테스트로 설계 먼저)**

`test/unit/domain/auth_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/core/error/failures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('AuthRepository', () {
    test('signInWithApple 성공 시 User 반환', () async {
      const expected = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => repository.signInWithApple())
          .thenAnswer((_) async => expected);

      final result = await repository.signInWithApple();

      expect(result, equals(expected));
    });

    test('signInWithGoogle 성공 시 User 반환', () async {
      const expected = User(id: 'uid-2', email: 'g@test.com', isPremium: false);
      when(() => repository.signInWithGoogle())
          .thenAnswer((_) async => expected);

      final result = await repository.signInWithGoogle();

      expect(result, equals(expected));
    });

    test('signOut 호출 가능', () async {
      when(() => repository.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => repository.signOut()).called(1);
    });

    test('currentUser 스트림 제공', () {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => repository.currentUser)
          .thenAnswer((_) => Stream.value(user));

      expect(repository.currentUser, emits(user));
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/domain/auth_repository_test.dart
```

Expected: FAIL — "Target of URI doesn't exist"

**Step 3: 인터페이스 구현**

`lib/domain/repositories/auth_repository.dart`:

```dart
import 'package:habit_rabbit/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<User?> get currentUser;
  Future<User> signInWithApple();
  Future<User> signInWithGoogle();
  Future<void> signOut();
}
```

**Step 4: 테스트 실행 → 통과 확인**

```bash
flutter test test/unit/domain/auth_repository_test.dart
```

Expected: PASS (4/4)

**Step 5: 커밋**

```bash
git add lib/domain/repositories/auth_repository.dart test/unit/domain/auth_repository_test.dart
git commit -m "feat: add AuthRepository interface"
```

---

## Task 4: Habit 엔티티 (TDD)

**Files:**

- Create: `lib/domain/entities/habit.dart`
- Create: `test/unit/domain/habit_test.dart`

**Step 1: 실패하는 테스트 작성**

`test/unit/domain/habit_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

void main() {
  group('Habit entity', () {
    test('같은 id를 가지면 동일하다', () {
      final habit1 = Habit(
        id: 'habit-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      final habit2 = Habit(
        id: 'habit-1',
        userId: 'uid-1',
        name: '다른 이름',
        createdAt: DateTime(2026, 3, 8),
        isActive: false,
      );

      expect(habit1, equals(habit2));
    });

    test('isActive false인 습관은 비활성 상태', () {
      final habit = Habit(
        id: 'habit-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: false,
      );

      expect(habit.isActive, isFalse);
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/domain/habit_test.dart
```

Expected: FAIL

**Step 3: 최소 구현**

`lib/domain/entities/habit.dart`:

```dart
import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final bool isActive;

  const Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });

  @override
  List<Object> get props => [id];
}
```

**Step 4: 테스트 실행 → 통과 확인**

```bash
flutter test test/unit/domain/habit_test.dart
```

Expected: PASS

**Step 5: 커밋**

```bash
git add lib/domain/entities/habit.dart test/unit/domain/habit_test.dart
git commit -m "feat: add Habit entity"
```

---

## Task 5: Checkin 엔티티 + 당근 포인트 계산 (TDD)

**Files:**

- Create: `lib/domain/entities/checkin.dart`
- Create: `test/unit/domain/checkin_test.dart`

**Step 1: 실패하는 테스트 작성**

`test/unit/domain/checkin_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';

void main() {
  group('Checkin 당근 포인트', () {
    test('스트릭 0일: 기본 10포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );

      expect(checkin.carrotPoints, equals(10));
    });

    test('스트릭 6일(7일 달성): 보너스 5포인트 추가 = 15포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 6,
      );

      expect(checkin.carrotPoints, equals(15));
    });

    test('스트릭 29일(30일 달성): 보너스 10포인트 추가 = 20포인트', () {
      final checkin = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 29,
      );

      expect(checkin.carrotPoints, equals(20));
    });

    test('(habit-1, uid-1, 2026-03-07) 동일 조합은 동일한 체크인', () {
      final c1 = Checkin(
        id: 'c-1',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 0,
      );
      final c2 = Checkin(
        id: 'c-2',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
        streakDay: 5,
      );

      expect(c1, equals(c2));
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/domain/checkin_test.dart
```

Expected: FAIL

**Step 3: 최소 구현**

`lib/domain/entities/checkin.dart`:

```dart
import 'package:equatable/equatable.dart';

class Checkin extends Equatable {
  final String id;
  final String habitId;
  final String userId;
  final DateTime date;
  final int streakDay;

  const Checkin({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.streakDay,
  });

  /// 당근 포인트: 기본 10 + 스트릭 보너스
  /// 7일 달성 (streakDay == 6): +5
  /// 30일 달성 (streakDay == 29): +10
  int get carrotPoints {
    int points = 10;
    if (streakDay == 29) {
      points += 10;
    } else if (streakDay == 6) {
      points += 5;
    }
    return points;
  }

  /// 멱등성 키: (habitId, userId, date)로 중복 체크인 방지
  String get idempotencyKey =>
      '${habitId}_${userId}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  List<Object> get props => [habitId, userId, date];
}
```

**Step 4: 테스트 실행 → 통과 확인**

```bash
flutter test test/unit/domain/checkin_test.dart
```

Expected: PASS

**Step 5: 커밋**

```bash
git add lib/domain/entities/checkin.dart test/unit/domain/checkin_test.dart
git commit -m "feat: add Checkin entity with carrot point calculation and idempotency key"
```

---

## Task 6: HabitRepository 인터페이스 (TDD)

**Files:**

- Create: `lib/domain/repositories/habit_repository.dart`
- Create: `test/unit/domain/habit_repository_test.dart`

**Step 1: 실패하는 테스트 작성**

`test/unit/domain/habit_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository repository;

  setUp(() {
    repository = MockHabitRepository();
    registerFallbackValue(Habit(
      id: 'h-1',
      userId: 'uid-1',
      name: '운동',
      createdAt: DateTime(2026, 3, 7),
      isActive: true,
    ));
  });

  group('HabitRepository', () {
    test('getHabits: 사용자 습관 목록 반환', () async {
      final habits = [
        Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true),
      ];
      when(() => repository.getHabits(userId: 'uid-1'))
          .thenAnswer((_) async => habits);

      final result = await repository.getHabits(userId: 'uid-1');

      expect(result, equals(habits));
    });

    test('addHabit: 습관 추가 후 반환', () async {
      final habit = Habit(id: 'h-1', userId: 'uid-1', name: '운동', createdAt: DateTime(2026, 3, 7), isActive: true);
      when(() => repository.addHabit(any())).thenAnswer((_) async => habit);

      final result = await repository.addHabit(habit);

      expect(result.name, equals('운동'));
    });

    test('checkIn: 체크인 후 Checkin 반환', () async {
      final checkin = Checkin(id: 'c-1', habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 7), streakDay: 0);
      when(() => repository.checkIn(habitId: 'h-1', userId: 'uid-1', date: DateTime(2026, 3, 7)))
          .thenAnswer((_) async => checkin);

      final result = await repository.checkIn(
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, 7),
      );

      expect(result.carrotPoints, equals(10));
    });
  });
}
```

**Step 2: 테스트 실행 → 실패 확인**

```bash
flutter test test/unit/domain/habit_repository_test.dart
```

Expected: FAIL

**Step 3: 인터페이스 구현**

`lib/domain/repositories/habit_repository.dart`:

```dart
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits({required String userId});
  Future<Habit> addHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit({required String habitId, required String userId});
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  });
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  });
}
```

**Step 4: 테스트 실행 → 통과 확인**

```bash
flutter test test/unit/domain/habit_repository_test.dart
```

Expected: PASS

**Step 5: 커밋**

```bash
git add lib/domain/repositories/habit_repository.dart test/unit/domain/habit_repository_test.dart
git commit -m "feat: add HabitRepository interface"
```

---

## Task 7: 전체 단위 테스트 실행 확인

**Step 1: 전체 테스트 실행**

```bash
flutter test test/unit/
```

Expected: 모든 테스트 PASS, 에러 없음

**Step 2: 현재까지 구현 상태 정리 커밋**

```bash
git add .
git commit -m "chore: domain layer complete - entities and repository interfaces"
```

---

## 다음 계획 (Task 8+)

다음 계획 파일: `docs/plans/2026-03-07-mvp-data-layer.md`

- Task 8: Firebase Auth 구현체 (FirebaseAuthRepository)
- Task 9: Firestore HabitRepository 구현체 (멱등성 포함)
- Task 10: RevenueCat SubscriptionRepository
- Task 11: Riverpod Provider 설정
- Task 12: main.dart + Firebase 초기화
