# Habit Rabbit MVP Customization — Implementation Plan

**Goal:** 구매한 아이템 장착/해제 (Story 11)

---

## Task 84: ShopRepository equip/unequip + equippedItemsProvider (TDD) ✅

**Files:**

- Modify: `lib/domain/repositories/shop_repository.dart`
- Modify: `lib/data/repositories/in_memory_shop_repository.dart`
- Create: `lib/presentation/providers/equipped_items_provider.dart`
- Create: `test/unit/domain/equip_item_test.dart`

**RED**: 테스트:

```dart
test('아이템 장착 후 장착 목록에 포함', () async { ... });
test('아이템 해제 후 장착 목록에서 제거', () async { ... });
test('소유하지 않은 아이템은 장착 불가', () async { ... });
```

**GREEN**: ShopRepository에 equipItem/unequipItem/getEquippedItems 추가.
equippedItemsProvider(FutureProvider) 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add equip/unequip to ShopRepository"
```

---

## Task 85: CustomizationScreen 위젯 (TDD) ✅

**Files:**

- Create: `lib/presentation/screens/customization_screen.dart`
- Create: `test/widget/customization_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('소유 아이템 목록 표시', (tester) async { ... });
testWidgets('장착된 아이템에 "장착 중" 배지 표시', (tester) async { ... });
testWidgets('장착 버튼 탭 시 장착 상태 변경', (tester) async { ... });
```

**GREEN**: CustomizationScreen — 소유 아이템 ListView, 장착/해제 버튼.

**Step 5: 커밋**

```bash
git commit -m "feat: add CustomizationScreen"
```

---

## Task 86: ShopScreen → CustomizationScreen 연결 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/shop_screen.dart`
- Modify: `test/widget/shop_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('"꾸미기" 버튼 탭 시 CustomizationScreen으로 이동', (tester) async { ... });
```

**GREEN**: ShopScreen AppBar에 꾸미기 IconButton 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: navigate to CustomizationScreen from ShopScreen"
```

---

## Task 87: HabitListScreen 장착 아이템 표시 (TDD) ✅

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('장착된 아이템 이름이 AppBar에 표시', (tester) async { ... });
```

**GREEN**: AppBar subtitle 또는 아이콘으로 장착 아이템 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show equipped items in HabitListScreen"
```

---

## Task 88: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: customization complete"
```
