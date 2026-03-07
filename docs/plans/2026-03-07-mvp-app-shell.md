# Habit Rabbit MVP App Shell — Implementation Plan

**Goal:** main.dart Riverpod 연결, 기본 스크린 뼈대, 위젯 테스트

---

## Task 25: main.dart + HabitRabbitApp (TDD)

**Files:**

- Modify: `lib/main.dart`
- Create: `test/widget/app_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: wire ProviderScope and HabitRabbitApp in main.dart"
```

---

## Task 26: HabitListScreen 뼈대 (TDD)

**Files:**

- Create: `lib/presentation/screens/habit_list_screen.dart`
- Create: `test/widget/habit_list_screen_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add HabitListScreen scaffold"
```

---

## Task 27: LoginScreen 뼈대 (TDD)

**Files:**

- Create: `lib/presentation/screens/login_screen.dart`
- Create: `test/widget/login_screen_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add LoginScreen scaffold"
```

---

## Task 28: 전체 테스트 통과 확인

```bash
flutter test test/unit/ && flutter test test/widget/
git commit -m "chore: app shell complete"
```
