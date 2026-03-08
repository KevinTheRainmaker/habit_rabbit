# Habit Rabbit MVP UX Polish — Implementation Plan

**Goal:** 온보딩 스킵 + 당근 보너스 개선 + 습관 상세 UX

---

## Task 125: 온보딩 스킵 버튼 (TDD) ✅ (이미 구현됨)

Story 28 AC: 온보딩 화면에 "건너뛰기" 옵션, 스킵 시 빈 습관 목록으로 진입.

**Files:**

- Modify: `lib/presentation/screens/onboarding_screen.dart`
- Modify: `test/widget/onboarding_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('온보딩 화면에 건너뛰기 버튼 표시', (tester) async { ... });
testWidgets('건너뛰기 탭 시 onSkip 콜백 호출', (tester) async { ... });
```

**GREEN**: OnboardingScreen에 "건너뛰기" TextButton 추가, onSkip 콜백 파라미터.

**Step 5: 커밋**

```bash
git commit -m "feat: add skip button to OnboardingScreen"
```

---

## Task 126: 스트릭 보너스 포인트 계산 개선 (TDD) ✅ (이미 구현됨 — Checkin.carrotPoints)

Story 9 AC: 스트릭 일수에 따른 보너스 지급 (7일 +5%, 30일 +10%, 최대 +30%).

**Files:**

- Modify: `lib/domain/entities/checkin.dart`
- Modify: `test/unit/domain/checkin_test.dart`

**RED**: 테스트:

```dart
test('7일 스트릭 → 기본 10 + 보너스 1 = 11', () { ... });
test('30일 스트릭 → 기본 10 + 보너스 2 = 12', () { ... });
test('스트릭 없으면 기본 10', () { ... });
```

**GREEN**: Checkin.carrotPoints getter에 스트릭 보너스 로직 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: add streak bonus to carrot points"
```

---

## Task 127: HabitDetailScreen 개선 (TDD) ✅ (이미 구현됨 — 달성률 + 최장 스트릭 표시)

## Task 127b: HabitReadinessCard onAdd 연결 (TDD) ✅

현재 `onAdd: () {}` — 실제로 AddHabitDialog를 표시해야 함.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('준비 제안 카드 추가하기 탭 시 AddHabitDialog 표시', (tester) async { ... });
```

**GREEN**: `onAdd: () => _showAddHabitDialog(context, ref, widget.user)` 연결.

**Step 5: 커밋**

```bash
git commit -m "feat: wire up HabitReadinessCard onAdd to AddHabitDialog"
```

---

## Task 128: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp ux polish complete"
```
