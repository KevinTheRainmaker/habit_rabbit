# Habit Rabbit MVP Pull-to-Refresh & 에러 상태 — Implementation Plan

**Goal:** 사용자가 습관 목록을 수동으로 새로고침할 수 있고, 로딩 실패 시 에러 상태를 표시

현재 문제:

- 습관 목록이 자동으로 갱신되지만, 사용자가 수동으로 새로고침할 방법이 없음
- 네트워크/데이터 로딩 실패 시 빈 화면만 표시 (에러 메시지 없음)

---

## Task 241: 습관 목록 Pull-to-Refresh (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('아래로 당기면 습관 목록이 새로고침됨', (tester) async { ... });
```

**GREEN**:

`_HabitListBody`의 `ListView`를 `RefreshIndicator`로 감싸기:

```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(habitsListProvider(userId));
  },
  child: ListView.builder(...),
)
```

**Step 5: 커밋**

```bash
git commit -m "feat: pull-to-refresh habit list"
```

---

## Task 242: 습관 목록 에러 상태 표시 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('습관 로딩 실패 시 에러 메시지 표시', (tester) async { ... });
```

**GREEN**:

`_HabitListBody.build()`에서 `habitsAsync.hasError`일 때 에러 위젯 표시:

```dart
if (habitsAsync.hasError) {
  return Center(
    child: Column(children: [
      const Icon(Icons.error_outline, size: 48),
      const SizedBox(height: 8),
      const Text('습관을 불러오지 못했어요'),
      TextButton(
        onPressed: () => ref.invalidate(habitsListProvider(userId)),
        child: const Text('다시 시도'),
      ),
    ]),
  );
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: show error state when habit loading fails"
```

---

## Task 243: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp pull-refresh and error state complete"
```
