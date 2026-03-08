# Habit Rabbit MVP 미션 자동 달성 — Implementation Plan

**Goal:** 체크인/습관 추가 등 이벤트 발생 시 해당 미션 자동 완료 처리

---

## Task 203: MissionCheckUseCase (TDD)

체크인 수, 습관 수, 스트릭 기반으로 완료해야 할 미션 ID 목록을 반환하는 유스케이스.

**Files:**

- Create: `lib/domain/usecases/mission_check_usecase.dart`
- Create: `test/unit/domain/mission_check_usecase_test.dart`

**RED**: 테스트:

```dart
test('첫 체크인 시 mission-first-checkin 반환', () { ... });
test('체크인 0개면 빈 목록', () { ... });
test('7일 연속 스트릭이면 mission-7day-streak 포함', () { ... });
```

**GREEN**: `MissionCheckUseCase(totalCheckins, habitCount, bestStreak).pendingMissionIds` → List<String>.

**Step 5: 커밋**

```bash
git commit -m "feat: add MissionCheckUseCase to detect completable missions"
```

---

## Task 204: 체크인 후 미션 자동 완료 (TDD)

HabitListScreen 체크인 성공 시 MissionCheckUseCase로 달성 미션을 확인하고 completeMission 호출.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트: "첫 체크인 완료 시 mission-first-checkin 미션 완료 처리"

**GREEN**: `_HabitListBodyState._checkIn()` 내에서 체크인 후 미션 체크 + completeMission 호출.

**Step 5: 커밋**

```bash
git commit -m "feat: auto-complete missions on checkin events"
```

---

## Task 205: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp mission autocheck complete"
```
