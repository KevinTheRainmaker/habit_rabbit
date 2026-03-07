# Habit Rabbit MVP Missions & Polish — Implementation Plan

**Goal:** 미션 달성 아이템 보상 (Story 12) + 습관 추가 준비 제안 카드 (Story 23)

---

## Task 94: Mission 엔티티 + MissionRepository 인터페이스 (TDD)

**Files:**

- Create: `lib/domain/entities/mission.dart`
- Create: `lib/domain/repositories/mission_repository.dart`
- Create: `test/unit/domain/mission_test.dart`

**RED**: 테스트:

```dart
test('기본 미션 엔티티', () { ... });
test('달성 여부 확인', () { ... });
test('같은 id는 동일하다', () { ... });
```

**GREEN**: Mission(id, title, description, isCompleted, rewardItemId) 엔티티 + MissionRepository 인터페이스.

**Step 5: 커밋**

```bash
git commit -m "feat: add Mission entity and MissionRepository"
```

---

## Task 95: InMemoryMissionRepository (TDD)

**Files:**

- Create: `lib/data/repositories/in_memory_mission_repository.dart`
- Create: `lib/presentation/providers/mission_provider.dart`
- Create: `test/unit/domain/mission_repository_test.dart`

**RED**: 테스트:

```dart
test('MissionRepository를 구현한다', () { ... });
test('5개 기본 미션 반환', () async { ... });
test('completeMission 후 isCompleted=true', () async { ... });
test('이미 완료된 미션 재완료 시 예외', () async { ... });
```

**GREEN**: InMemoryMissionRepository 구현 (5개 기본 미션 포함). missionsProvider(FutureProvider).

**Step 5: 커밋**

```bash
git commit -m "feat: add InMemoryMissionRepository and missionProvider"
```

---

## Task 96: CheckMissionUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/check_mission_usecase.dart`
- Create: `test/unit/domain/check_mission_usecase_test.dart`

**RED**: 테스트:

```dart
test('첫 습관 완료 미션 달성 조건', () { ... });
test('7일 스트릭 미션 달성 조건', () { ... });
test('30일 스트릭 미션 달성 조건', () { ... });
```

**GREEN**: CheckMissionUseCase(checkinCount, currentStreak) → List<String> (달성된 미션 id 목록).

**Step 5: 커밋**

```bash
git commit -m "feat: add CheckMissionUseCase"
```

---

## Task 97: MissionScreen 위젯 (TDD)

**Files:**

- Create: `lib/presentation/screens/mission_screen.dart`
- Create: `test/widget/mission_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('미션 목록 표시', (tester) async { ... });
testWidgets('완료된 미션에 체크 표시', (tester) async { ... });
testWidgets('미완료 미션에 진행 상태 표시', (tester) async { ... });
```

**GREEN**: MissionScreen — ListView of missions with 완료/미완료 상태 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: add MissionScreen"
```

---

## Task 98: HabitReadinessSuggestionCard (TDD) — Story 23

**Files:**

- Create: `lib/presentation/widgets/habit_readiness_card.dart`
- Create: `test/widget/habit_readiness_card_test.dart`

**RED**: 테스트:

```dart
testWidgets('7일 달성률 80% 이상 시 카드 표시', (tester) async { ... });
testWidgets('"추가하기" 버튼 표시', (tester) async { ... });
testWidgets('"아직은 괜찮아" 버튼 탭 시 카드 숨김', (tester) async { ... });
```

**GREEN**: HabitReadinessCard — 조건부 표시 카드 위젯.

**Step 5: 커밋**

```bash
git commit -m "feat: add HabitReadinessCard"
```

---

## Task 99: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: missions and readiness card complete"
```
