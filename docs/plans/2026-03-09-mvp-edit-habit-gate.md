# Habit Rabbit MVP Edit Habit & Free Tier Gate — Implementation Plan

**Goal:** EditHabitDialog 요일 편집 + 무료 사용자 습관 3개 초과 게이팅

---

## Task 139: EditHabitDialog 요일 편집 (TDD) ✅

Story 2 AC: 이름, 반복 요일 수정 가능.

**Files:**

- Modify: `lib/presentation/screens/edit_habit_dialog.dart`
- Create: `test/widget/edit_habit_dialog_test.dart`

**RED**: 테스트:

```dart
testWidgets('편집 다이얼로그에 요일 선택 버튼 표시', (tester) async { ... });
testWidgets('요일 수정 후 저장 시 업데이트된 targetDays 전달', (tester) async { ... });
```

**GREEN**: EditHabitDialog에 AddHabitDialog와 동일한 요일 토글 추가. onSaved 시그니처를 `void Function(String name, List<int> targetDays)?`로 변경. habit_list_screen.dart 콜사이트 업데이트.

**Step 5: 커밋**

```bash
git commit -m "feat: add targetDays editing to EditHabitDialog"
```

---

## Task 140: 무료 사용자 습관 3개 초과 시 프리미엄 게이트 (TDD) ✅ (이미 구현됨)

Story 1 AC: 무료 사용자가 3개 초과 생성 시도 시 업셀 화면으로 이동.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자 습관 3개 초과 시 프리미엄 게이트 표시', (tester) async { ... });
```

**GREEN**: FAB(또는 AddHabit 버튼) 탭 시 무료 사용자의 전체 습관 수가 3개 이상이면 PremiumGateScreen을 push.

**Step 5: 커밋**

```bash
git commit -m "feat: show premium gate when free user exceeds 3 habits"
```

---

## Task 141: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp edit habit gate complete"
```
