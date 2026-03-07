# Habit Rabbit MVP Item Shop — Implementation Plan

**Goal:** 당근 포인트로 아이템 구매 (Story 10)

---

## Task 78: ShopItem 엔티티 (TDD) ✅

**Files:**

- Create: `lib/domain/entities/shop_item.dart`
- Create: `test/unit/domain/shop_item_test.dart`

**RED**: 테스트:

```dart
test('같은 id는 동일하다', () { ... });
test('가격은 양수여야 한다', () { ... });
```

**GREEN**: ShopItem(id, name, price, category, isOwned) 엔티티.

**Step 5: 커밋**

```bash
git commit -m "feat: add ShopItem entity"
```

---

## Task 79: ShopRepository 인터페이스 + InMemory 구현 (TDD) ✅

**Files:**

- Create: `lib/domain/repositories/shop_repository.dart`
- Create: `lib/data/repositories/in_memory_shop_repository.dart`
- Create: `test/unit/domain/shop_repository_test.dart`

**RED**: 테스트:

```dart
test('기본 아이템 목록 반환', () async { ... });
test('아이템 구매 시 소유 목록에 추가', () async { ... });
test('잔액 부족 시 예외 발생', () async { ... });
```

**GREEN**: InMemoryShopRepository 구현 (기본 5개 아이템 내장).

**Step 5: 커밋**

```bash
git commit -m "feat: add ShopRepository and InMemory impl"
```

---

## Task 80: shopProvider (TDD) ✅

**Files:**

- Create: `lib/presentation/providers/shop_provider.dart`
- Create: `test/unit/domain/shop_provider_test.dart`

**RED**: 테스트:

```dart
test('shopItemsProvider는 아이템 목록을 반환한다', () async { ... });
test('purchaseItem 후 아이템이 owned 상태로 변경', () async { ... });
```

**GREEN**: shopRepositoryProvider + shopItemsProvider(FutureProvider) + ShopNotifier.

**Step 5: 커밋**

```bash
git commit -m "feat: add shopProvider"
```

---

## Task 81: ShopScreen 위젯 (TDD) ✅

**Files:**

- Create: `lib/presentation/screens/shop_screen.dart`
- Create: `test/widget/shop_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('아이템 목록 표시', (tester) async { ... });
testWidgets('소유한 아이템에 "보유" 배지 표시', (tester) async { ... });
testWidgets('구매 버튼 탭 시 carrotPoints 차감', (tester) async { ... });
testWidgets('잔액 부족 시 "당근이 부족해요" 표시', (tester) async { ... });
```

**GREEN**: ShopScreen — GridView로 아이템 표시, 구매 버튼, 잔액 확인.

**Step 5: 커밋**

```bash
git commit -m "feat: add ShopScreen"
```

---

## Task 82: HabitListScreen 샵 버튼 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('당근 포인트 탭 시 ShopScreen으로 이동', (tester) async { ... });
```

**GREEN**: 당근 포인트 텍스트를 GestureDetector로 감싸서 ShopScreen으로 네비게이션.

**Step 5: 커밋**

```bash
git commit -m "feat: navigate to ShopScreen from carrot points"
```

---

## Task 83: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: item shop complete"
```
