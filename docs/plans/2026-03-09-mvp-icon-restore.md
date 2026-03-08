# Habit Rabbit MVP Icon & Restore — Implementation Plan

**Goal:** 습관 아이콘 선택 + 구독 복원 버튼

---

## Task 162: Habit 엔티티 icon 필드 추가 (TDD) ✅

Story 1 AC: 아이콘 선택(기본값 제공).

**Files:**

- Modify: `lib/domain/entities/habit.dart`
- Modify: `test/unit/domain/habit_test.dart`

**RED**: 테스트:

```dart
test('icon 필드 기본값은 빈 문자열', () { ... });
test('icon 포함 Habit 생성', () { ... });
```

**GREEN**: Habit에 `final String icon` 필드 추가, 기본값 `''`, copyWith 포함.

**Step 5: 커밋**

```bash
git commit -m "feat: add icon field to Habit entity"
```

---

## Task 163: AddHabitDialog 아이콘 선택 UI (TDD) ✅

Story 1 AC: 아이콘 선택 UI.

**Files:**

- Modify: `lib/presentation/screens/add_habit_dialog.dart`
- Modify: `test/widget/add_habit_dialog_test.dart`

**RED**: 테스트:

```dart
testWidgets('아이콘 선택 버튼 표시', (tester) async { ... });
testWidgets('아이콘 선택 시 선택된 아이콘 업데이트', (tester) async { ... });
```

**GREEN**: 이모지 목록(최소 6개) 가로 스크롤 행 추가. 선택 아이콘 저장하여 onSaved에 전달.

**Step 5: 커밋**

```bash
git commit -m "feat: add icon picker to AddHabitDialog"
```

---

## Task 164: 구독 복원 버튼 + 완료 축하 화면 (TDD) ✅

Story 20 AC: "구독 복원" 버튼 제공.
Story 22 AC: 구독 완료 후 "프리미엄 토끼가 됐어요!" 축하 화면.

**Files:**

- Modify: `lib/presentation/screens/premium_gate_screen.dart`
- Modify: `test/widget/premium_gate_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('구독 복원 버튼 표시', (tester) async { ... });
testWidgets('구독하기 탭 시 프리미엄 토끼 축하 메시지 표시', (tester) async { ... });
```

**GREEN**: "구독 복원하기" TextButton 추가. 업그레이드 버튼 탭 시 "프리미엄 토끼가 됐어요!" 스낵바/다이얼로그.

**Step 5: 커밋**

```bash
git commit -m "feat: add restore button and success message to PremiumGateScreen"
```

---

## Task 165: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp icon restore complete"
```
