# Habit Rabbit MVP UI Wiring — Implementation Plan

**Goal:** 인증 상태 기반 라우팅 + HabitListScreen 실제 데이터 연결

---

## Task 29: 인증 상태 기반 라우팅 (TDD)

currentUser 상태에 따라 LoginScreen/HabitListScreen 전환.

**Files:**

- Modify: `lib/main.dart`
- Create: `test/widget/auth_routing_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: auth-aware routing in HabitRabbitApp"
```

---

## Task 30: HabitListScreen 실제 데이터 연결 (TDD)

habitListProvider에서 습관 목록을 로드하여 ListView로 표시.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: connect HabitListScreen to habitListProvider"
```

---

## Task 31: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: UI wiring complete"
```
