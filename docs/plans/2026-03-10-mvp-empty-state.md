# Habit Rabbit MVP 빈 상태 개선 — Implementation Plan

**Goal:** 오늘 습관이 없는 경우와 습관 자체가 없는 경우를 구분하여 적절한 빈 상태 표시

현재 문제:

- `TodayHabitsUseCase`로 필터링 후 오늘 습관이 없으면 항상 `EmptyHabitState` 표시
- 하지만 "오늘 요일에 등록된 습관이 없는 경우" (쉬는 날)에도 "첫 습관 추가하기" 버튼이 표시됨
- 사용자가 의도적으로 오늘을 쉬는 날로 설정했는데 "등록된 습관이 없어요" 표시는 잘못된 메시지

---

## Task 244: 오늘 습관 없음 vs. 전체 습관 없음 구분 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('습관이 있지만 오늘 요일에 해당 없으면 쉬는 날 메시지 표시', (tester) async { ... });
```

**GREEN**:

`habit_list_screen.dart`에서 `habits.isEmpty` 분기를 두 경우로 나눔:

```dart
if (allHabits.isEmpty) {
  return EmptyHabitState(onAdd: () => _showAddHabitDialog(context, user));
}
if (habits.isEmpty) {
  return const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('😴', style: TextStyle(fontSize: 48)),
        SizedBox(height: 16),
        Text('오늘은 쉬는 날이에요!', style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 8),
        Text('내일 또 달려봐요 🐰', style: TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    ),
  );
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: show rest-day state when no habits scheduled for today"
```

---

## Task 245: 전체 테스트 통과 확인 ✅

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp empty state improvement complete"
```
