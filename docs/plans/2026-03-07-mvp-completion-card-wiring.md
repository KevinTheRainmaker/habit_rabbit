# Habit Rabbit MVP Completion Card Wiring + Edit Habit — Implementation Plan

**Goal:** CompletionRateCard를 HabitListScreen에 연결 + 습관 편집 기능

---

## Task 49: CompletionRateCard를 HabitListScreen에 연결 (TDD)

HabitListScreen 상단에 CompletionRateCard 표시.
체크인 기록을 합산해 달성률 계산 후 카드에 전달.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('HabitListScreen에 CompletionRateCard 표시', (tester) async {
  // 로그인 + 습관 있음 → CompletionRateCard 위젯 찾기
  expect(find.byType(CompletionRateCard), findsOneWidget);
});
```

**GREEN**: HabitListScreen body에 CompletionRateCard 추가:

- `checkinsListProvider`로 각 습관의 체크인 조합
- `MonthlyCompletionRateUseCase`로 달성률 계산
- ListView 위에 `CompletionRateCard(rate: rate)` 배치

**Step 5: 커밋**

```bash
git commit -m "feat: wire CompletionRateCard into HabitListScreen"
```

---

## Task 50: EditHabitDialog 위젯 (TDD)

습관 이름 수정 다이얼로그.

**Files:**

- Create: `lib/presentation/screens/edit_habit_dialog.dart`
- Create: `test/widget/edit_habit_dialog_test.dart`

**RED**: 테스트:

```dart
testWidgets('기존 이름 미리 채워짐', (tester) async {
  // EditHabitDialog(habit: habit) → TextField에 habit.name 표시
});
testWidgets('이름 수정 후 저장 시 콜백 호출', (tester) async { ... });
testWidgets('빈 이름 저장 시 유효성 오류', (tester) async { ... });
```

**GREEN**: EditHabitDialog 구현 (AddHabitDialog와 유사, 초기값 있음).

**Step 5: 커밋**

```bash
git commit -m "feat: add EditHabitDialog widget"
```

---

## Task 51: 습관 편집 UI 연결 (TDD)

\_HabitTile 롱프레스 → EditHabitDialog → HabitListNotifier.updateHabit.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `lib/presentation/providers/habit_provider.dart`
- Modify: `test/widget/habit_list_screen_test.dart`
- Modify: `test/unit/presentation/habit_list_notifier_test.dart`

**RED**: 테스트:

```dart
testWidgets('롱프레스 시 편집 다이얼로그 열림', (tester) async {
  // longPress on tile → EditHabitDialog appears
});
test('updateHabit: 습관 이름 수정', () async { ... });
```

**GREEN**:

- `HabitListNotifier`에 `updateHabit` 메서드 추가
- `_HabitTile`에 `onLongPress: _onLongPress` → `showModalBottomSheet`

**Step 5: 커밋**

```bash
git commit -m "feat: long-press to edit habit"
```

---

## Task 52: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: completion card wiring + edit habit complete"
```
