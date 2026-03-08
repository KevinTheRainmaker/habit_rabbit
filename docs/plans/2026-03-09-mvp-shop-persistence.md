# Habit Rabbit MVP 샵 영속성 — Implementation Plan

**Goal:** 구매한 아이템과 장착 정보가 앱 재시작 후에도 유지

---

## Task 191: HiveShopRepository (TDD)

Hive Box에 구매/장착 아이템 ID를 저장하는 ShopRepository 구현.

**Files:**

- Create: `lib/data/repositories/hive_shop_repository.dart`
- Create: `test/unit/data/hive_shop_repository_test.dart`

**RED**: 테스트:

```dart
test('구매한 아이템이 getOwnedItems에 포함됨', () { ... });
test('장착한 아이템이 getEquippedItems에 포함됨', () { ... });
test('이미 보유한 아이템 재구매 시 예외', () { ... });
```

**GREEN**: `HiveShopRepository(box)` — owned/equipped 키를 Hive에 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveShopRepository for persistent shop state"
```

---

## Task 192: main.dart에 HiveShopRepository 연결

main.dart에서 shopBox를 열고 HiveShopRepository를 shopRepositoryProvider에 주입.

**Files:**

- Modify: `lib/main.dart`

**RED**: 현재 shopRepositoryProvider는 InMemoryShopRepository를 반환 — 재시작 시 초기화됨

**GREEN**: main.dart에 shopBox 열기 + shopRepositoryProvider.overrideWithValue 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: wire HiveShopRepository in main.dart for persistent shop"
```

---

## Task 193: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp shop persistence complete"
```
