# Habit Rabbit MVP 통계 화면 날짜 개선 — Implementation Plan

**Goal:** StatisticsScreen에서도 currentDateProvider 사용 + 체크인 날짜 일관성 확보

현재 문제:

- `statistics_screen.dart`의 `today = DateTime.now()` (line 37)
- `statistics_screen.dart`의 `WeeklyCompletionRateUseCase(..., today: DateTime.now())` (line 68)
- `habit_list_screen.dart`의 `date: DateTime.now()` (체크인 날짜 = 실제 현재 시각 — 이것은 올바른 동작이므로 유지)

---

## Task 230: StatisticsScreen에서 currentDateProvider 사용 (TDD)

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('StatisticsScreen이 currentDateProvider 날짜로 주간 달성률 계산', (tester) async { ... });
```

**GREEN**:

- `statistics_screen.dart` import에 `date_provider.dart` 추가
- `final today = DateTime.now()` → `final today = ref.watch(currentDateProvider)`
- 중복된 `DateTime.now()` (line 68) → `today` 변수 사용

**Step 5: 커밋**

```bash
git commit -m "fix: use currentDateProvider in StatisticsScreen"
```

---

## Task 231: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp statistics date complete"
```
