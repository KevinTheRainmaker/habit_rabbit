# Habit Rabbit MVP Refinements — Implementation Plan

**Goal:** 삭제 확인 다이얼로그 + 스트릭 마일스톤 + 페이월 개선

---

## Task 120: 삭제 확인 다이얼로그 (TDD) ✅

Story 2 AC: 삭제 시 "삭제하면 기록도 사라져요" 확인 다이얼로그 표시.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('습관 스와이프 삭제 시 확인 다이얼로그 표시', (tester) async { ... });
testWidgets('확인 누르면 deleteHabit 호출', (tester) async { ... });
testWidgets('취소 누르면 deleteHabit 미호출', (tester) async { ... });
```

**GREEN**: `onDismissed` 대신 `confirmDismiss`로 변경, AlertDialog("삭제하면 기록도 사라져요") 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: add delete confirmation dialog"
```

---

## Task 121: StreakMilestoneUseCase (TDD) ✅

Story 5 AC: 5, 10, 30, 100일 달성 시 마일스톤 메시지 반환.

**Files:**

- Create: `lib/domain/usecases/streak_milestone_usecase.dart`
- Create: `test/unit/domain/streak_milestone_usecase_test.dart`

**RED**: 테스트:

```dart
test('5일 달성 → 마일스톤 메시지 반환', () { ... });
test('10일 달성 → 마일스톤 메시지 반환', () { ... });
test('30일 달성 → 마일스톤 메시지 반환', () { ... });
test('100일 달성 → 마일스톤 메시지 반환', () { ... });
test('마일스톤 아닌 날 → null 반환', () { ... });
```

**GREEN**: `StreakMilestoneUseCase(streak: int).message` → String? 반환.

**Step 5: 커밋**

```bash
git commit -m "feat: add StreakMilestoneUseCase"
```

---

## Task 122: 체크인 후 마일스톤 메시지 표시 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('체크인 후 5일 마일스톤이면 메시지 표시', (tester) async { ... });
```

**GREEN**: `_HabitTileState._onTap`에서 체크인 후 `StreakMilestoneUseCase`로 메시지 확인,
`_streak`이 마일스톤이면 subtitle에 메시지 추가 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show streak milestone message after checkin"
```

---

## Task 123: 페이월 화면 개선 (TDD)

Story 22 AC: 무료 vs 유료 기능 비교 표시.

**Files:**

- Modify: `lib/presentation/screens/premium_gate_screen.dart`
- Modify: `test/widget/premium_gate_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 vs 유료 기능 비교 목록 표시', (tester) async { ... });
testWidgets('업그레이드 CTA 버튼 표시', (tester) async { ... });
testWidgets('나중에 버튼 표시', (tester) async { ... });
```

**GREEN**: PremiumGateScreen에 기능 비교 Row 목록 (습관 수, 알림, 통계, 복구권, 아이템) 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: improve paywall screen with feature comparison"
```

---

## Task 124: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp refinements complete"
```
