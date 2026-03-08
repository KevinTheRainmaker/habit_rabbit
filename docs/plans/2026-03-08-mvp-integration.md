# Habit Rabbit MVP Integration — Implementation Plan

**Goal:** 새로 만든 위젯/화면들을 기존 앱 흐름에 연결

---

## Task 100: MissionScreen 네비게이션 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('미션 아이콘 탭 시 MissionScreen으로 이동', (tester) async { ... });
```

**GREEN**: HabitListScreen AppBar에 미션 아이콘 버튼 추가 → MissionScreen으로 이동.

**Step 5: 커밋**

```bash
git commit -m "feat: navigate to MissionScreen from HabitListScreen"
```

---

## Task 101: HabitReadinessCard를 HabitListScreen에 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `lib/presentation/providers/habit_providers.dart` (또는 기존 provider)
- Create: `test/widget/habit_list_readiness_card_test.dart`

**RED**: 테스트:

```dart
testWidgets('달성률 80% 이상이고 습관 3개 미만이면 HabitReadinessCard 표시', (tester) async { ... });
testWidgets('달성률 80% 미만이면 HabitReadinessCard 미표시', (tester) async { ... });
```

**GREEN**: HabitListScreen 하단에 HabitReadinessCard 조건부 삽입.

**Step 5: 커밋**

```bash
git commit -m "feat: show HabitReadinessCard in HabitListScreen"
```

---

## Task 102: StreakBreakDialog 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Create: `test/widget/streak_break_dialog_integration_test.dart`

**RED**: 테스트:

```dart
testWidgets('스트릭 끊김 감지 시 StreakBreakDialog 표시', (tester) async { ... });
testWidgets('"괜찮아, 다시 시작할게" 탭 시 다이얼로그 닫힘', (tester) async { ... });
```

**GREEN**: HabitListScreen이 StreakBreakCheckUseCase 결과를 보고 dialog 자동 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show StreakBreakDialog on streak break detection"
```

---

## Task 103: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp integration complete"
```
