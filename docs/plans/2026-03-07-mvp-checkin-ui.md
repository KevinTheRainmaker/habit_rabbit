# Habit Rabbit MVP CheckIn UI — Implementation Plan

**Goal:** 핵심 습관 루프 UI 완성 — 체크인 인터랙션 + 당근 포인트 표시

---

## Task 32: CarrotPointsNotifier (TDD)

당근 포인트 누적 상태를 관리하는 StateNotifier.

**Files:**

- Create: `lib/presentation/providers/carrot_points_provider.dart`
- Create: `test/unit/presentation/carrot_points_provider_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add CarrotPointsNotifier provider"
```

---

## Task 33: HabitListScreen 체크인 인터랙션 (TDD)

습관 타일 탭 → 체크인 → 당근 포인트 적립 → 시각적 피드백.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: habit tile check-in interaction with carrot points"
```

---

## Task 34: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: check-in UI complete"
```
