# Habit Rabbit MVP Remaining Use Cases & Routing — Implementation Plan

**Goal:** CRUD 완성 (Delete/Update/GetCheckins) + 앱 라우팅 뼈대

---

## Task 21: DeleteHabitUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/delete_habit_usecase.dart`
- Create: `test/unit/domain/delete_habit_usecase_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add DeleteHabitUseCase"
```

---

## Task 22: UpdateHabitUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/update_habit_usecase.dart`
- Create: `test/unit/domain/update_habit_usecase_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add UpdateHabitUseCase"
```

---

## Task 23: GetCheckinsUseCase (TDD)

**Files:**

- Create: `lib/domain/usecases/get_checkins_usecase.dart`
- Create: `test/unit/domain/get_checkins_usecase_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add GetCheckinsUseCase"
```

---

## Task 24: 전체 테스트 통과 확인

```bash
flutter test test/unit/
git commit -m "chore: remaining use cases complete"
```
