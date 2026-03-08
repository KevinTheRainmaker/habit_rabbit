# Habit Rabbit MVP 온보딩 추천 & 통계 개선 — Implementation Plan

**Goal:** Story 14 "1개부터 시작" 강조 + Story 4 달성률 메시지 개선 + Story 5 최장 스트릭

---

## Task 169: HabitRecommendationScreen "오늘은 1개만 시작해요" 강조 (TDD)

Story 14 AC: 퀴즈 후 습관 선택 화면에서 "오늘은 1개만 시작해요" 문구 강조 표시.

**Files:**

- Modify: `lib/presentation/screens/habit_recommendation_screen.dart`
- Modify: `test/widget/habit_recommendation_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('"오늘은 1개만 시작해요" 강조 텍스트 표시', (tester) async { ... });
```

**GREEN**: 앱바 아래에 `'오늘은 1개만 시작해요'` 강조 텍스트 추가 (bold, 큰 글자).

**Step 5: 커밋**

```bash
git commit -m "feat: add '오늘은 1개만 시작해요' emphasis to HabitRecommendationScreen"
```

---

## Task 170: CompletionRateCard 스트릭 0 + 달성률 70%+ 특별 메시지 (TDD)

Story 4 AC: 스트릭 0이지만 달성률 70% 이상이면 긍정 메시지 ("이번 달 70% 달성했어, 잘하고 있어!").

**Files:**

- Modify: `lib/presentation/widgets/completion_rate_card.dart`
- Modify: `test/widget/completion_rate_card_test.dart`

**RED**: 테스트:

```dart
testWidgets('스트릭 0이고 달성률 70% 이상이면 특별 메시지 표시', (tester) async { ... });
```

**GREEN**: `CompletionRateCard`에 `currentStreak` 파라미터 추가. streak==0 && rate>=0.7이면 "이번 달 70% 달성했어, 잘하고 있어!" 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show positive message when streak 0 but monthly rate >= 70%"
```

---

## Task 171: 최장 스트릭 UseCase + StatisticsScreen 표시 (TDD)

Story 5 AC: 최장 스트릭(All-time best) 별도 기록 및 표시.

**Files:**

- Create: `lib/domain/usecases/best_streak_usecase.dart`
- Create: `test/unit/domain/best_streak_usecase_test.dart`
- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
test('체크인 날짜 목록에서 최장 연속 스트릭 계산', () { ... });
testWidgets('통계 화면에 최장 스트릭 표시', (tester) async { ... });
```

**GREEN**: `BestStreakUseCase(checkins: List<DateTime>).bestStreak` → int 반환. StatisticsScreen에 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: add BestStreakUseCase and display in StatisticsScreen"
```

---

## Task 172: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp onboarding recommend complete"
```
