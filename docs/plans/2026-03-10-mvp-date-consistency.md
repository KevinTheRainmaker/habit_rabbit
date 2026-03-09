# Habit Rabbit MVP 날짜 일관성 개선 — Implementation Plan

**Goal:** 모든 화면에서 `DateTime.now()` 대신 `currentDateProvider` 사용으로 날짜 일관성 확보

현재 문제:

- `_HabitListBody._weeklyRate()`에서 `DateTime.now()` 직접 사용
- `_HabitListBody.build()`의 `today = DateTime.now()` (StreakBreakCheck)
- `HabitDetailScreen.build()`의 `today = DateTime.now()`
- 날짜가 변경되어도 해당 위젯들이 갱신되지 않음

---

## ✅ Task 227: \_HabitListBody에서 currentDateProvider 사용 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('날짜 변경 시 스트릭 브레이크 체크가 갱신됨', (tester) async { ... });
```

**GREEN**:

- `_HabitListBody`를 `ConsumerStatefulWidget`으로 변환 (이미 그럼)
- `_weeklyRate()`에 `today` 파라미터 추가
- `build()`에서 `ref.watch(currentDateProvider)` 사용
- `_weeklyRate()` 및 `StreakBreakCheckUseCase`에 `currentDateProvider` 값 전달

**Step 5: 커밋**

```bash
git commit -m "fix: use currentDateProvider in _HabitListBody for consistent date"
```

---

## ✅ Task 228: HabitDetailScreen에서 currentDateProvider 사용 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_detail_screen.dart`
- Modify: `test/widget/habit_detail_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('HabitDetailScreen이 currentDateProvider 날짜를 사용함', (tester) async { ... });
```

**GREEN**:

- `HabitDetailScreen.build()`에서 `DateTime.now()` → `ref.watch(currentDateProvider)` 변경

**Step 5: 커밋**

```bash
git commit -m "fix: use currentDateProvider in HabitDetailScreen"
```

---

## ✅ Task 229: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp date consistency complete"
```
