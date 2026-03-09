# Habit Rabbit MVP 체크인 상태 영속성 — Implementation Plan

**Goal:** 앱 재시작 후에도 오늘 체크인 상태를 올바르게 복원

현재 문제:

- `_HabitTile._checkedIn`이 로컬 상태로 관리됨 (초기값 = false)
- 앱 재시작 후 오늘 체크인한 습관도 미체크인으로 표시됨
- 사용자가 다시 탭 → 예외 발생 → 조용히 무시 → 혼란

---

## Task 236: \_HabitTile 체크인 상태를 checkinsListProvider에서 파생 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('기존 오늘 체크인이 있으면 체크인 완료 아이콘 표시', (tester) async { ... });
```

**GREEN**:

- `_HabitTileState.build()`에서 `checkinsListProvider`를 watch
- 오늘 날짜(`currentDateProvider`)와 일치하는 체크인이 있으면 `_checkedIn` 초기화
- 단, 세션 중 체크인한 경우 (`_sessionCheckedIn`) 우선 적용

구현 방식:

```dart
final checkinsAsync = ref.watch(
  checkinsListProvider((habitId: widget.habit.id, userId: widget.userId)),
);
final today = ref.watch(currentDateProvider);
final alreadyCheckedIn = checkinsAsync.valueOrNull?.any(
  (c) => c.date.year == today.year && c.date.month == today.month && c.date.day == today.day,
) ?? false;
final checkedIn = _sessionCheckedIn || alreadyCheckedIn;
```

**Step 5: 커밋**

```bash
git commit -m "fix: restore today checkin state from provider in _HabitTile"
```

---

## Task 237: 전체 테스트 통과 확인 ✅

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp checkin state persistence complete"
```
