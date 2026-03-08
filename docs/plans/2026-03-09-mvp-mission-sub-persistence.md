# Habit Rabbit MVP 미션/구독 영속성 — Implementation Plan

**Goal:** 미션 완료 상태 및 프리미엄 구독 상태를 재시작 후에도 유지

---

## Task 200: HiveMissionRepository (TDD)

Hive Box에 완료된 미션 ID 목록을 저장하는 MissionRepository 구현.

**Files:**

- Create: `lib/data/repositories/hive_mission_repository.dart`
- Create: `test/unit/data/hive_mission_repository_test.dart`

**RED**: 테스트:

```dart
test('초기에는 미션이 미완료 상태', () { ... });
test('completeMission 후 해당 미션 isCompleted=true 영속', () { ... });
test('이미 완료된 미션 재완료 시 예외', () { ... });
```

**GREEN**: `HiveMissionRepository(box)` — 완료 ID Set을 Hive에 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveMissionRepository for persistent mission state"
```

---

## Task 201: HiveSubscriptionRepository (TDD)

Hive Box에 프리미엄 구독 상태를 저장하는 SubscriptionRepository 구현.

**Files:**

- Create: `lib/data/repositories/hive_subscription_repository.dart`
- Create: `test/unit/data/hive_subscription_repository_test.dart`

**RED**: 테스트:

```dart
test('초기 프리미엄 상태 false', () { ... });
test('purchasePremium 후 isPremium=true 영속', () { ... });
test('restorePurchases 이전 구매 복원', () { ... });
```

**GREEN**: `HiveSubscriptionRepository(box)` — Hive에 bool 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveSubscriptionRepository for persistent premium state"
```

---

## Task 202: main.dart 연결 + 전체 테스트

main.dart에서 missionBox, subscriptionBox 열기 + provider 오버라이드.

**Files:**

- Modify: `lib/main.dart`

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp mission sub persistence complete"
```
