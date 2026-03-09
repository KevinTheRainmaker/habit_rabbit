# Habit Rabbit MVP 입력 유효성 검사 — Implementation Plan

**Goal:** 습관 추가/편집 시 발생할 수 있는 엣지케이스 방어

현재 문제:

- `AddHabitDialog`: 요일을 하나도 선택하지 않아도 저장 가능 → 습관이 절대 표시되지 않음
- `EditHabitDialog`: 동일 문제
- 습관 이름 최대 글자 제한 없음 → UI가 깨질 수 있음

---

## Task 232: AddHabitDialog 빈 요일 유효성 검사 (TDD)

**Files:**

- Modify: `lib/presentation/screens/add_habit_dialog.dart`
- Modify: `test/widget/add_habit_dialog_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('요일 미선택 시 저장 불가 에러 메시지 표시', (tester) async { ... });
```

**GREEN**:

- `_onSave()`에서 `_selectedDays.isEmpty` 체크 추가
- `'최소 하나의 요일을 선택해주세요'` 에러 표시

**Step 5: 커밋**

```bash
git commit -m "fix: validate at least one day selected in AddHabitDialog"
```

---

## Task 233: EditHabitDialog 빈 요일 유효성 검사 (TDD)

**Files:**

- Modify: `lib/presentation/screens/edit_habit_dialog.dart`
- Modify: `test/widget/edit_habit_dialog_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('요일 미선택 시 저장 불가 에러 메시지 표시', (tester) async { ... });
```

**GREEN**: `EditHabitDialog._onSave()`에도 동일 검사 추가

**Step 5: 커밋**

```bash
git commit -m "fix: validate at least one day selected in EditHabitDialog"
```

---

## Task 234: 습관 이름 최대 30자 제한 (TDD)

**Files:**

- Modify: `lib/presentation/screens/add_habit_dialog.dart`
- Modify: `lib/presentation/screens/edit_habit_dialog.dart`
- Modify: `test/widget/add_habit_dialog_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('31자 이상 입력 시 저장 불가', (tester) async { ... });
```

**GREEN**: `TextField`에 `maxLength: 30` 추가, `_onSave()`에서 길이 검사

**Step 5: 커밋**

```bash
git commit -m "feat: add 30-char max length for habit name"
```

---

## Task 235: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp input validation complete"
```
