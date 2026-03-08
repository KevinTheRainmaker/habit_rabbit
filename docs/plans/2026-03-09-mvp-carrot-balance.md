# Habit Rabbit MVP 당근 잔액 정확성 — Implementation Plan

**Goal:** 재시작 후 당근 잔액 = 획득 총합 - 구매 지출 합산으로 정확히 계산

---

## Task 194: CarrotBalanceUseCase (TDD)

체크인에서 획득한 포인트와 보유 아이템 가격 합산을 빼서 실제 잔액을 계산.

**Files:**

- Create: `lib/domain/usecases/carrot_balance_usecase.dart`
- Create: `test/unit/domain/carrot_balance_usecase_test.dart`

**RED**: 테스트:

```dart
test('체크인 획득 - 구매 지출 = 잔액', () { ... });
test('구매 없으면 획득 총합 = 잔액', () { ... });
```

**GREEN**: `CarrotBalanceUseCase(checkins, ownedItems).balance` → int.

**Step 5: 커밋**

```bash
git commit -m "feat: add CarrotBalanceUseCase to compute net carrot balance"
```

---

## Task 195: HabitListScreen 잔액 초기화 수정 (TDD)

기존 `initialize(total earned)`를 `initialize(balance = earned - spent)`로 교체.
`ownedItems`를 shopRepositoryProvider에서 읽어 차감.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트: "구매한 아이템 가격만큼 당근 포인트 차감해서 잔액 표시"

**GREEN**: `_HabitListBodyState.build()`에서 ownedItems를 읽어 `CarrotBalanceUseCase`로 초기화.

**Step 5: 커밋**

```bash
git commit -m "feat: initialize carrot balance accounting for shop purchases"
```

---

## Task 196: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp carrot balance complete"
```
