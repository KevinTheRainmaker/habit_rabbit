# Habit Rabbit MVP Habit Schedule — Implementation Plan

**Goal:** 습관 추가 시 요일 선택 + 달성률 카드 긍정 메시지

---

## Task 133: AddHabitDialog 반복 요일 선택 (TDD) ✅

Story 1 AC: 이름(필수), 반복 요일 설정 가능.

**Files:**

- Modify: `lib/presentation/screens/add_habit_dialog.dart`
- Modify: `test/widget/add_habit_dialog_test.dart`

**RED**: 테스트:

```dart
testWidgets('요일 선택 버튼 표시', (tester) async { ... });
testWidgets('요일 선택 후 저장 시 targetDays 포함', (tester) async { ... });
```

**GREEN**: AddHabitDialog에 요일 토글 버튼(월~일) 추가.
onSaved 시그니처를 `void Function(String name, List<int> targetDays)` 로 변경.

**Step 5: 커밋**

```bash
git commit -m "feat: add target days selection to AddHabitDialog"
```

---

## Task 134: CompletionRateCard 긍정 메시지 (TDD) ✅

Story 4 AC: 달성률 70% 이상이면 긍정 메시지 ("잘하고 있어!" 등).

**Files:**

- Modify: `lib/presentation/widgets/completion_rate_card.dart`
- Modify: `test/widget/completion_rate_card_test.dart`

**RED**: 테스트:

```dart
testWidgets('달성률 70% 이상이면 긍정 메시지 표시', (tester) async { ... });
testWidgets('달성률 70% 미만이면 긍정 메시지 미표시', (tester) async { ... });
```

**GREEN**: CompletionRateCard에 rate >= 0.7 조건으로 긍정 메시지 Text 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: show motivational message in CompletionRateCard"
```

---

## Task 135: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp habit schedule complete"
```
