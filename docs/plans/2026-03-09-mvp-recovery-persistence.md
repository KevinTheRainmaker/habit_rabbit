# Habit Rabbit MVP 복구권 영속성 — Implementation Plan

**Goal:** 스트릭 복구권(무료 체험 사용 여부 + 보유 티켓 수)을 재시작 후에도 유지

---

## Task 197: HiveRecoveryRepository (TDD)

Hive Box에 userId별 RecoveryTicket 상태를 저장하는 RecoveryRepository 구현.

**Files:**

- Create: `lib/data/repositories/hive_recovery_repository.dart`
- Create: `test/unit/data/hive_recovery_repository_test.dart`

**RED**: 테스트:

```dart
test('초기 티켓은 count=0, freeTrialUsed=false', () { ... });
test('useFreeTrial 후 freeTrialUsed=true 영속', () { ... });
test('티켓 없을 때 useTicket 예외', () { ... });
```

**GREEN**: `HiveRecoveryRepository(box)` — Hive에 userId 키로 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveRecoveryRepository for persistent recovery tickets"
```

---

## Task 198: main.dart에 HiveRecoveryRepository 연결

**Files:**

- Modify: `lib/main.dart`

**GREEN**: recoveryBox 열기 + recoveryRepositoryProvider.overrideWithValue 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: wire HiveRecoveryRepository in main.dart"
```

---

## Task 199: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp recovery persistence complete"
```
