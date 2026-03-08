# Habit Rabbit MVP Progress — Implementation Plan

**Goal:** 오늘 진행률 표시 + 통계 강화 + 스트릭 보너스 개선

---

## Task 116: TodayProgressUseCase (TDD) ✅

오늘 완료한 습관 수 / 오늘의 전체 습관 수를 계산.

**Files:**

- Create: `lib/domain/usecases/today_progress_usecase.dart`
- Create: `test/unit/domain/today_progress_usecase_test.dart`

**RED**: 테스트:

```dart
test('오늘 습관 2개 중 1개 완료 → 1/2', () { ... });
test('완료 없으면 0/n', () { ... });
test('오늘 습관 없으면 0/0', () { ... });
```

**GREEN**: TodayProgressUseCase(checkins, habits, today) → (completed: int, total: int).

**Step 5: 커밋**

```bash
git commit -m "feat: add TodayProgressUseCase"
```

---

## Task 117: HabitListScreen에 오늘 진행률 표시 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('오늘 진행률 텍스트 표시 (예: "0 / 1")', (tester) async { ... });
```

**GREEN**: \_HabitListBody 상단에 오늘 완료/전체 텍스트 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show today progress in HabitListScreen"
```

---

## Task 118: StatisticsScreen에 총 적립 포인트 표시 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('총 적립 포인트 표시', (tester) async { ... });
```

**GREEN**: StatisticsScreen에 allCheckins.fold로 carrotPoints 합계 \_StatCard 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: show total carrot points in StatisticsScreen"
```

---

## Task 119: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp progress complete"
```
