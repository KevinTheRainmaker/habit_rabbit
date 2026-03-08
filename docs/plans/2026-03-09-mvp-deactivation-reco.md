# Habit Rabbit MVP 구독 만료 비활성화 & 맞춤 추천 — Implementation Plan

**Goal:** Story 26 구독 만료 시 초과 습관 비활성화 + Story 13 온보딩 답변 기반 맞춤 추천

---

## Task 176: HabitDeactivationUseCase — 구독 만료 시 초과 습관 비활성화 (TDD)

Story 26 AC: 초과된 습관(4개+)은 비활성화 처리 (삭제 아님) — 재구독 시 복원.

**Files:**

- Create: `lib/domain/usecases/habit_deactivation_usecase.dart`
- Create: `test/unit/domain/habit_deactivation_usecase_test.dart`

**RED**: 테스트:

```dart
test('무료 한도(3개) 초과 시 초과분 비활성화 반환', () { ... });
test('프리미엄이면 모든 습관 활성 유지', () { ... });
test('3개 이하면 비활성화 없음', () { ... });
```

**GREEN**: `HabitDeactivationUseCase(habits, isPremium, freeLimit).deactivatedHabits` → 초과 습관들.

**Step 5: 커밋**

```bash
git commit -m "feat: add HabitDeactivationUseCase for subscription expiry"
```

---

## Task 177: 온보딩 답변 기반 맞춤 습관 추천 (TDD)

Story 13 AC: 답변 기반으로 2-3개 맞춤 습관 추천 (예: "아침형이라면 — 물 한 잔, 스트레칭").

**Files:**

- Create: `lib/domain/usecases/habit_recommendation_usecase.dart`
- Create: `test/unit/domain/habit_recommendation_usecase_test.dart`
- Modify: `lib/presentation/screens/habit_recommendation_screen.dart`
- Modify: `lib/presentation/screens/app_router.dart`
- Modify: `test/widget/habit_recommendation_screen_test.dart`

**RED**: 테스트:

```dart
test('아침 루틴 선택 시 아침 추천 습관 반환', () { ... });
test('건강 목표 선택 시 운동 관련 습관 추천', () { ... });
```

**GREEN**: `HabitRecommendationUseCase(answers).recommendations` → List<String>.
HabitRecommendationScreen에 answers 파라미터 추가, 추천 목록을 answers 기반으로 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: add HabitRecommendationUseCase for personalized onboarding"
```

---

## Task 178: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp deactivation reco complete"
```
