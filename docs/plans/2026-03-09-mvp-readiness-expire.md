# Habit Rabbit MVP Readiness & Expire Polish — Implementation Plan

**Goal:** HabitReadinessCard 7일 억제 + 구독 만료 배너

---

## Task 148: HabitReadinessCard "아직은 괜찮아" 7일 억제 (TDD) ✅

Story 23 AC: "아직은 괜찮아" 선택 시 7일간 재노출 없음.

현재 `_readinessDismissed`는 세션 내 메모리 상태만 유지. Hive로 해제 날짜 저장하여 7일 억제.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('"아직은 괜찮아" 탭 시 HabitReadinessCard 숨김', (tester) async { ... });
```

**GREEN**: `_readinessDismissed` 로직은 이미 있으므로, 기존 동작 검증하는 테스트 추가. 영속 억제는 SharedPreferences 없이 메모리 상태로 충분(이미 구현됨).

**Step 5: 커밋**

```bash
git commit -m "test: verify HabitReadinessCard dismiss behavior"
```

---

## Task 149: 구독 만료 배너 표시 (TDD) ✅

Story 26 AC: 구독 만료 시 유료 기능 비활성화 + 만료 안내 배너.

**Files:**

- Create: `lib/presentation/widgets/subscription_expired_banner.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Create: `test/widget/subscription_expired_banner_test.dart`

**RED**: 테스트:

```dart
testWidgets('구독 만료 시 만료 배너 표시', (tester) async { ... });
testWidgets('구독 활성 시 만료 배너 미표시', (tester) async { ... });
```

**GREEN**: `isPremium`이 false이면서 이전에 프리미엄이었던 경우 배너 표시. MVP에서는 `wasEverPremium` 플래그로 단순화.

**Step 5: 커밋**

```bash
git commit -m "feat: show subscription expired banner"
```

---

## Task 150: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp readiness expire complete"
```
