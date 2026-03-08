# Habit Rabbit MVP Icon Display & Edit — Implementation Plan

**Goal:** 습관 아이콘 목록 표시 + 편집 다이얼로그 아이콘 선택

---

## Task 166: HabitListScreen에 습관 아이콘 표시 (TDD) ✅

Story 11: 메인 화면에서 현재 꾸며진 토끼굴 실시간 반영 + 아이콘 표시.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('습관 목록에 아이콘이 있으면 아이콘 표시', (tester) async { ... });
```

**GREEN**: ListTile의 leading에 `habit.icon.isNotEmpty ? Text(habit.icon) : null` 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: display habit icon in HabitListScreen"
```

---

## Task 167: EditHabitDialog 아이콘 선택 UI + onSaved 시그니처 업데이트 (TDD) ✅

Story 2 AC: 아이콘 수정 가능.

**Files:**

- Modify: `lib/presentation/screens/edit_habit_dialog.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/edit_habit_dialog_test.dart`

**RED**: 테스트:

```dart
testWidgets('편집 다이얼로그에 아이콘 선택 버튼 표시', (tester) async { ... });
```

**GREEN**: EditHabitDialog에 아이콘 피커 추가. onSaved 시그니처를 `(name, days, icon)`으로 변경.

**Step 5: 커밋**

```bash
git commit -m "feat: add icon picker to EditHabitDialog"
```

---

## Task 168: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp icon display complete"
```
