# Habit Rabbit MVP Streak Recovery — Implementation Plan

**Goal:** 스트릭 복구권 시스템 + 첫 실패 위로 플로우 (Story 7, 8)

---

## Task 89: RecoveryTicket 엔티티 + RecoveryRepository 인터페이스 (TDD) ✅

**Files:**

- Create: `lib/domain/entities/recovery_ticket.dart`
- Create: `lib/domain/repositories/recovery_repository.dart`
- Create: `test/unit/domain/recovery_ticket_test.dart`

**RED**: 테스트:

```dart
test('기본 무료 티켓 1개', () { ... });
test('티켓 사용 후 잔량 감소', () { ... });
test('무료 체험 사용 여부 추적', () { ... });
```

**GREEN**: RecoveryTicket(count, freeTrialUsed) 엔티티 + RecoveryRepository 인터페이스.

**Step 5: 커밋**

```bash
git commit -m "feat: add RecoveryTicket entity and RecoveryRepository"
```

---

## Task 90: InMemoryRecoveryRepository + recoveryProvider (TDD)

**Files:**

- Create: `lib/data/repositories/in_memory_recovery_repository.dart`
- Create: `lib/presentation/providers/recovery_provider.dart`
- Create: `test/unit/domain/recovery_repository_test.dart`

**RED**: 테스트:

```dart
test('초기 티켓 상태 반환', () async { ... });
test('복구 후 streakDay 복원', () async { ... });
test('무료 체험 후 freeTrialUsed = true', () async { ... });
```

**GREEN**: InMemoryRecoveryRepository 구현. recoveryTicketProvider(FutureProvider).

**Step 5: 커밋**

```bash
git commit -m "feat: add InMemoryRecoveryRepository and recoveryProvider"
```

---

## Task 91: StreakBreakDialog 위젯 (TDD)

스트릭이 끊겼을 때 보여주는 위로 + 복구 선택 다이얼로그.

**Files:**

- Create: `lib/presentation/screens/streak_break_dialog.dart`
- Create: `test/widget/streak_break_dialog_test.dart`

**RED**: 테스트:

```dart
testWidgets('위로 메시지 표시', (tester) async { ... });
testWidgets('"무료 복구권 사용하기" 버튼 표시 (미사용 시)', (tester) async { ... });
testWidgets('"괜찮아, 다시 시작할게" 버튼 표시', (tester) async { ... });
testWidgets('무료 체험 이미 사용 시 복구권 버튼 비활성화', (tester) async { ... });
```

**GREEN**: StreakBreakDialog 구현 — Column with 위로 텍스트 + 두 개 버튼.

**Step 5: 커밋**

```bash
git commit -m "feat: add StreakBreakDialog"
```

---

## Task 92: CheckInUseCase 스트릭 끊김 감지 (TDD)

**Files:**

- Create: `lib/domain/usecases/streak_break_check_usecase.dart`
- Create: `test/unit/domain/streak_break_check_usecase_test.dart`

**RED**: 테스트:

```dart
test('오늘 미체크 + 어제 체크 있으면 스트릭 유지 중', () { ... });
test('오늘 미체크 + 어제 체크 없으면 스트릭 끊김', () { ... });
test('체크인 없으면 끊김 아님', () { ... });
```

**GREEN**: StreakBreakCheckUseCase(checkins, today) → bool.

**Step 5: 커밋**

```bash
git commit -m "feat: add StreakBreakCheckUseCase"
```

---

## Task 93: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: streak recovery complete"
```
