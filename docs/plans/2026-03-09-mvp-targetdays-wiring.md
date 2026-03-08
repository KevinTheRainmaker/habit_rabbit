# Habit Rabbit MVP TargetDays Wiring — Implementation Plan

**Goal:** AddHabitDialog에서 선택한 targetDays를 실제 Habit 저장에 연결 + 오늘 요일 필터 연동

---

## Task 136: addHabit에 targetDays 파라미터 연결 (TDD) ✅

AddHabitDialog에서 `(name, days)` 콜백으로 받은 `days`가 현재 `addHabit(name:, userId:)` 호출 시 버려지고 있음. `targetDays`를 실제로 저장하도록 연결.

**Files:**

- Modify: `lib/presentation/providers/habit_provider.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/unit/presentation/habit_provider_test.dart` (또는 적절한 테스트 파일)

**RED**: 테스트:

```dart
test('addHabit은 targetDays를 포함해 저장한다', () async { ... });
```

**GREEN**: `addHabit` 시그니처를 `addHabit({required String name, required String userId, List<int>? targetDays})` 로 변경. habit 생성 시 `targetDays: targetDays ?? _allDays` 적용. habit_list_screen.dart 두 콜사이트에서 `days`를 전달.

**Step 5: 커밋**

```bash
git commit -m "feat: wire targetDays from AddHabitDialog to addHabit"
```

---

## Task 137: 오늘 요일 필터 — TodayHabitsUseCase 연동 확인 (TDD) ✅

HabitListScreen이 오늘 요일에 해당하는 습관만 표시하는지 확인. TodayHabitsUseCase가 이미 있지만 화면에 연동되지 않았을 수 있음.

**Files:**

- Check/Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('오늘 요일에 해당하는 습관만 표시', (tester) async { ... });
```

**GREEN**: HabitListScreen에서 `TodayHabitsUseCase`로 필터링된 목록을 사용해 렌더링.

**Step 5: 커밋**

```bash
git commit -m "feat: filter habits by today's weekday in HabitListScreen"
```

---

## Task 138: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp targetdays wiring complete"
```
