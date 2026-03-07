# Habit Rabbit MVP Statistics + Streak Detail — Implementation Plan

**Goal:** 통계 화면 (스트릭, 달성률 상세), HabitRepository getCheckins 활용

---

## Task 63: HabitDetailScreen 위젯 (TDD) ✅

습관 별 스트릭 + 이번 달 달성률 상세 화면.

**Files:**

- Create: `lib/presentation/screens/habit_detail_screen.dart`
- Create: `test/widget/habit_detail_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('습관 이름 표시', (tester) async { ... });
testWidgets('현재 스트릭 표시', (tester) async { ... });
testWidgets('이번 달 달성률 표시', (tester) async { ... });
```

**GREEN**: HabitDetailScreen 구현:

- 습관 이름, 스트릭, 달성률 카드
- checkinsListProvider로 체크인 기록 로드
- GetCheckinsUseCase.currentStreak() 활용

**Step 5: 커밋**

```bash
git commit -m "feat: add HabitDetailScreen"
```

---

## Task 64: HabitListScreen → HabitDetailScreen 네비게이션 (TDD) ✅

습관 타일 탭(체크인 아님) → 상세 화면 이동. 현재 탭은 체크인이므로 아이콘 버튼으로 분리.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('상세 버튼 탭 시 HabitDetailScreen으로 이동', (tester) async {
  // trailing에 info 아이콘 버튼 → 탭 → HabitDetailScreen
});
```

**GREEN**: \_HabitTile의 trailing에 InfoButton 추가, Navigator.push.

**Step 5: 커밋**

```bash
git commit -m "feat: navigate to HabitDetailScreen from tile"
```

---

## Task 65: AllTimeStreakUseCase (TDD) ✅

전체 기간 최장 스트릭 계산.

**Files:**

- Create: `lib/domain/usecases/all_time_streak_usecase.dart`
- Create: `test/unit/domain/all_time_streak_usecase_test.dart`

**RED**: 테스트:

```dart
test('연속 체크인 최장 스트릭 계산', () {
  // 1~5일 연속 + 7~9일 연속 → 최장 5일
});
test('체크인 없으면 0', () { ... });
```

**GREEN**: AllTimeStreakUseCase 구현 (날짜 정렬 후 연속성 판단).

**Step 5: 커밋**

```bash
git commit -m "feat: add AllTimeStreakUseCase"
```

---

## Task 66: HabitDetailScreen에 최장 스트릭 표시 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_detail_screen.dart`
- Modify: `test/widget/habit_detail_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('최장 스트릭 표시', (tester) async {
  // '역대 최장: 5일' 텍스트 확인
});
```

**GREEN**: HabitDetailScreen에 AllTimeStreakUseCase 결과 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: show all-time streak in HabitDetailScreen"
```

---

## Task 67: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: statistics screen complete"
```
