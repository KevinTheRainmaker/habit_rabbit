# Habit Rabbit MVP Add Habit Dialog — Implementation Plan

**Goal:** FAB → 습관 추가 다이얼로그 → 목록 갱신

---

## Task 35: AddHabitDialog 위젯 (TDD)

**Files:**

- Create: `lib/presentation/screens/add_habit_dialog.dart`
- Create: `test/widget/add_habit_dialog_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add AddHabitDialog widget"
```

---

## Task 36: HabitListScreen FAB 연결 (TDD)

FAB 탭 → AddHabitDialog 표시 → 저장 → 목록 갱신.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: connect FAB to AddHabitDialog"
```

---

## Task 37: HabitListNotifier (추가/갱신 상태 관리, TDD)

`habitListProvider`를 읽기 전용 FutureProvider에서 추가 기능을 갖춘 Notifier로 업그레이드.

**Files:**

- Modify: `lib/presentation/providers/habit_provider.dart`
- Create: `test/unit/presentation/habit_list_notifier_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: upgrade habitListProvider to support add habit"
```

---

## Task 38: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: add habit flow complete"
```
