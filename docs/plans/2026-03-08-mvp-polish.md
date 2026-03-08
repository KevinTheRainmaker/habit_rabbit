# Habit Rabbit MVP Polish — Implementation Plan

**Goal:** 복구권 Repository 연결 + 통계 화면 네비게이션 + 프리미엄 티저 (Story 19)

---

## Task 104: RecoveryRepository를 StreakBreakDialog에 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Create: `test/widget/streak_break_recovery_test.dart`

**RED**: 테스트:

```dart
testWidgets('freeTrialUsed=true이면 복구권 버튼 비활성화', (tester) async { ... });
testWidgets('"무료 복구권 사용하기" 탭 시 useFreeTrial 호출', (tester) async { ... });
```

**GREEN**: HabitListScreen이 recoveryRepositoryProvider에서 freeTrialUsed를 읽어 StreakBreakDialog에 전달.

**Step 5: 커밋**

```bash
git commit -m "feat: wire RecoveryRepository into StreakBreakDialog"
```

---

## Task 105: 통계 화면 네비게이션 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('통계 아이콘 탭 시 StatisticsScreen으로 이동', (tester) async { ... });
```

**GREEN**: HabitListScreen AppBar에 통계 아이콘 버튼 추가 → StatisticsScreen으로 이동.

**Step 5: 커밋**

```bash
git commit -m "feat: navigate to StatisticsScreen from HabitListScreen"
```

---

## Task 106: 프리미엄 통계 티저 위젯 (TDD) — Story 19

**Files:**

- Create: `lib/presentation/widgets/premium_teaser_banner.dart`
- Create: `test/widget/premium_teaser_banner_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자에게 티저 배너 표시', (tester) async { ... });
testWidgets('"업그레이드하기" 버튼 표시', (tester) async { ... });
testWidgets('프리미엄 사용자에게 티저 미표시', (tester) async { ... });
```

**GREEN**: PremiumTeaserBanner(isPremium, onUpgrade) 위젯.

**Step 5: 커밋**

```bash
git commit -m "feat: add PremiumTeaserBanner for premium upsell"
```

---

## Task 107: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp polish complete"
```
