# Habit Rabbit MVP Streak UI + Completion Rate — Implementation Plan

**Goal:** 스트릭 표시 + 이번 달 달성률 (Backlog Story 4, 5)

---

## Task 44: 스트릭 표시 위젯 (TDD)

HabitListScreen에 각 습관의 현재 스트릭 수 표시.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('습관 타일에 스트릭 수 표시', (tester) async {
  // checkInProvider를 mock해서 streak=3 반환
  // 타일에 '🔥 3' 또는 '3일 연속' 텍스트 확인
});
```

**GREEN**: `_HabitTileState`에 스트릭 로드 로직 추가:

- `checkInProvider`로 checkin 기록 가져오기
- `GetCheckinsUseCase.currentStreak()` 계산
- 타일에 스트릭 표시 (체크인 전후 모두)

**Step 5: 커밋**

```bash
git commit -m "feat: show streak count on habit tile"
```

---

## Task 45: GetCheckinsProvider (TDD)

체크인 기록을 스트림처럼 읽는 Provider.

**Files:**

- Create: `lib/presentation/providers/checkins_provider.dart`
- Create: `test/unit/presentation/checkins_provider_test.dart`

**RED**: 테스트:

```dart
test('checkinsProvider: 체크인 목록 반환', () async {
  // habitId, userId로 checkins 반환 확인
});
test('currentStreakProvider: 연속 스트릭 수 계산', () async {
  // 오늘 포함 연속 체크인 수 반환
});
```

**GREEN**: Provider 구현:

```dart
final checkinsProvider = FutureProvider.family<List<Checkin>, ({String habitId, String userId})>(
  (ref, args) async {
    final repo = ref.watch(habitRepositoryProvider);
    return repo.getCheckins(habitId: args.habitId, userId: args.userId);
  },
);
```

**Step 5: 커밋**

```bash
git commit -m "feat: add checkinsProvider"
```

---

## Task 46: 이번 달 달성률 (TDD)

습관별 이번 달 달성률(%) 계산 및 표시.

**Files:**

- Create: `lib/domain/usecases/monthly_completion_rate_usecase.dart`
- Create: `test/unit/domain/monthly_completion_rate_usecase_test.dart`

**RED**: 테스트:

```dart
test('달성률: 이번 달 완료일 / 목표일', () async {
  // 7일 중 5일 완료 → 71%
});
test('달성률: 체크인 없으면 0%', () async { ... });
```

**GREEN**: UseCase:

```dart
class MonthlyCompletionRateUseCase {
  // 당월 1일~오늘까지 목표일 중 완료일 비율 반환
  double call({required List<Checkin> checkins, required DateTime month}) { ... }
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: add MonthlyCompletionRateUseCase"
```

---

## Task 47: 달성률 UI 표시 (TDD)

HabitListScreen 상단에 전체 달성률 요약 카드 표시.

**Files:**

- Create: `lib/presentation/widgets/completion_rate_card.dart`
- Create: `test/widget/completion_rate_card_test.dart`

**RED**: 테스트:

```dart
testWidgets('달성률 카드: 퍼센트 표시', (tester) async {
  // CompletionRateCard(rate: 0.71) → '71%' 표시
});
testWidgets('달성률 0%일 때 격려 메시지', (tester) async {
  // rate=0 → '오늘 첫 체크인을 해보세요!' 표시
});
```

**GREEN**: `CompletionRateCard` 위젯 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add CompletionRateCard widget"
```

---

## Task 48: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: streak + completion rate UI complete"
```
