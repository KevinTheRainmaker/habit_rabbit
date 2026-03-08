# Habit Rabbit MVP Onboarding Polish — Implementation Plan

**Goal:** 온보딩 추천 화면 "1개부터 시작" 권장 메시지 + 스트릭 보너스 개선

---

## Task 142: HabitRecommendationScreen "1개만 시작" 권장 메시지 (TDD) ✅

Story 14 AC: 1개 선택 시 긍정 피드백 메시지 ("완벽한 시작이에요!"), 2-3개 시 부드러운 안내 ("처음엔 적을수록 좋아요").

**Files:**

- Modify: `lib/presentation/screens/habit_recommendation_screen.dart`
- Create: `test/widget/habit_recommendation_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('1개 선택 시 "완벽한 시작이에요!" 표시', (tester) async { ... });
testWidgets('2개 이상 선택 시 "처음엔 적을수록 좋아요" 표시', (tester) async { ... });
```

**GREEN**: 선택 수에 따른 메시지 Text 위젯 조건부 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show habit count guidance in HabitRecommendationScreen"
```

---

## Task 143: 스트릭 보너스 비율 기반 계산 (TDD) ✅

Story 9 AC: 7일 +5%, 30일 +10%, 최대 +30% (현재 고정 +5/+10). streakDay 기반 % 보너스로 개선.

**Files:**

- Modify: `lib/domain/entities/checkin.dart`
- Modify: `test/unit/domain/checkin_test.dart`

**RED**: 테스트:

```dart
test('7일 스트릭: 10 * 1.05 = 10 (정수 내림)', () { ... });
test('30일 스트릭: 10 * 1.10 = 11', () { ... });
```

**GREEN**: carrotPoints getter에서 % 보너스 적용. (10 \* bonusMultiplier).floor().

**Step 5: 커밋**

```bash
git commit -m "feat: apply percentage-based streak bonus to carrot points"
```

---

## Task 144: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp onboarding polish complete"
```
