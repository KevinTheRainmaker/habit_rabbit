# Habit Rabbit MVP Premium Gate + Subscription — Implementation Plan

**Goal:** 무료 사용자 습관 3개 제한 업셀 화면 + SubscriptionRepository 인터페이스 연결

---

## Task 53: PremiumGateScreen 위젯 (TDD)

무료 사용자가 습관 4개째 추가 시도 시 표시할 업셀 화면.

**Files:**

- Create: `lib/presentation/screens/premium_gate_screen.dart`
- Create: `test/widget/premium_gate_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('프리미엄 업셀 메시지 표시', (tester) async {
  // PremiumGateScreen → '프리미엄으로 업그레이드' 텍스트
});
testWidgets('닫기 버튼 존재', (tester) async { ... });
```

**GREEN**: PremiumGateScreen 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add PremiumGateScreen"
```

---

## Task 54: AddHabitUseCase 무료 제한 Provider 연결 (TDD)

HabitListNotifier.addHabit에서 무료 사용자 3개 초과 시 PremiumGateScreen 표시.

**Files:**

- Modify: `lib/presentation/providers/habit_provider.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자 3개 초과 시 업셀 화면', (tester) async {
  // 이미 3개 습관 있는 무료 사용자가 FAB 탭 → 추가 다이얼로그 대신 PremiumGateScreen
});
```

**GREEN**:

- `HabitListNotifier.addHabit`에서 `AddHabitUseCase` 활용
- 무료 사용자이고 3개 이상이면 `PremiumGateException` throw
- `HabitListScreen._showAddHabitDialog`에서 catch → PremiumGateScreen 표시

**Step 5: 커밋**

```bash
git commit -m "feat: enforce free tier habit limit with upsell"
```

---

## Task 55: InMemorySubscriptionRepository (TDD)

SubscriptionRepository 인터페이스의 InMemory 구현.

**Files:**

- Create: `lib/data/repositories/in_memory_subscription_repository.dart`
- Create: `test/unit/data/in_memory_subscription_repository_test.dart`

**RED**: 테스트:

```dart
test('초기 상태: isPremium false', () async { ... });
test('purchasePremium: true 반환', () async { ... });
test('restorePurchases: 구매 기록 없으면 false', () async { ... });
```

**GREEN**: InMemorySubscriptionRepository 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add InMemorySubscriptionRepository"
```

---

## Task 56: SubscriptionProvider (TDD)

구독 상태를 관리하는 Riverpod Provider.

**Files:**

- Create: `lib/presentation/providers/subscription_provider.dart`
- Create: `test/unit/presentation/subscription_provider_test.dart`

**RED**: 테스트:

```dart
test('isPremiumProvider: 초기 false', () async { ... });
test('purchasePremium 후 true', () async { ... });
```

**GREEN**: subscriptionRepositoryProvider + isPremiumProvider 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add subscriptionProvider"
```

---

## Task 57: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: premium gate + subscription provider complete"
```
