# Habit Rabbit MVP 자정 날짜 갱신 — Implementation Plan

**Goal:** 앱이 포그라운드에 있는 상태에서 자정이 지나도 날짜가 자동 갱신되도록 처리

현재 문제:

- `WidgetsBindingObserver.didChangeAppLifecycleState`로 앱 재개 시 날짜를 갱신하지만
- 앱이 자정에 포그라운드에 있으면 날짜가 갱신되지 않아 오전 12:01에도 어제 날짜로 표시
- 사용자가 앱을 종료했다 재시작해야만 날짜 갱신

---

## Task 238: 자정 타이머로 currentDateProvider 갱신 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('자정이 지나면 currentDateProvider가 새 날짜로 갱신됨', (tester) async { ... });
```

**GREEN**:

`_HabitListScreenState`에 `Timer? _midnightTimer` 추가.
`initState()`에서 자정까지 남은 시간을 계산해 타이머 설정:

```dart
void _scheduleMidnightRefresh() {
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final untilMidnight = tomorrow.difference(now);
  _midnightTimer = Timer(untilMidnight, () {
    if (mounted) {
      ref.read(currentDateProvider.notifier).state = DateTime.now();
      _scheduleMidnightRefresh(); // 다음 날 자정 예약
    }
  });
}
```

`dispose()`에서 `_midnightTimer?.cancel()`.

**Step 5: 커밋**

```bash
git commit -m "feat: auto-refresh date at midnight via timer in HabitListScreen"
```

---

## Task 239: 햅틱 피드백 — 체크인 시 진동 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가 (HapticFeedback mock 사용):

```dart
testWidgets('체크인 탭 시 햅틱 피드백 발생 확인', (tester) async { ... });
```

주: `HapticFeedback.mediumImpact()`는 `SystemChannels.platform`을 통해 호출되므로
`tester.binding.defaultBinaryMessenger.setMockMethodCallHandler`로 intercept.

**GREEN**:

`_HabitTile._onTap()`에서 체크인 성공 후 `HapticFeedback.mediumImpact()` 호출.

```dart
import 'package:flutter/services.dart';
// ...
await HapticFeedback.mediumImpact();
```

**Step 5: 커밋**

```bash
git commit -m "feat: haptic feedback on habit checkin"
```

---

## Task 240: 전체 테스트 통과 확인 ✅

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp midnight refresh and haptic complete"
```
