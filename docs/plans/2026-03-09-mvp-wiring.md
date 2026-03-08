# Habit Rabbit MVP Wiring — Implementation Plan

**Goal:** 새 위젯들을 기존 화면에 연결 + 통계 화면 주간 달성률 표시

---

## Task 112: EmptyHabitState를 HabitListScreen에 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('습관이 없으면 EmptyHabitState 표시', (tester) async { ... });
testWidgets('EmptyHabitState의 "첫 습관 추가하기" 탭 시 AddHabitDialog 열림', (tester) async { ... });
```

**GREEN**: HabitListScreen 빈 상태에서 `Text('습관을 추가해보세요!')` 대신 EmptyHabitState 사용.

**Step 5: 커밋**

```bash
git commit -m "feat: use EmptyHabitState in HabitListScreen"
```

---

## Task 113: StatisticsScreen에 isPremium 전달 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자 통계 화면에서 PremiumTeaserBanner 표시', (tester) async { ... });
```

**GREEN**: HabitListScreen의 통계 아이콘 탭 시 user.isPremium을 StatisticsScreen에 전달.

**Step 5: 커밋**

```bash
git commit -m "feat: pass isPremium to StatisticsScreen"
```

---

## Task 114: StatisticsScreen에 주간 달성률 표시 (TDD)

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('주간 달성률 표시', (tester) async { ... });
```

**GREEN**: StatisticsScreen에 WeeklyCompletionRateUseCase를 사용해 주간 달성률 \_StatCard 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: show weekly completion rate in StatisticsScreen"
```

---

## Task 115: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp wiring complete"
```
