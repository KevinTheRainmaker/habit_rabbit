# Habit Rabbit MVP Mission & Stats — Implementation Plan

**Goal:** 미션 자동 완료 연동 + 통계 화면 습관별 달성률 + 알림 저장 개선

---

## Task 129: MissionScreen 미션 자동 완료 감지 (TDD) ✅

현재 MissionScreen은 InMemoryMissionRepository의 초기값만 표시.
CheckMissionUseCase를 사용해 실제 체크인 수 기반으로 미션 완료 여부를 계산해 표시.

**Files:**

- Modify: `lib/presentation/screens/mission_screen.dart`
- Create: `test/widget/mission_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('미션 목록 표시', (tester) async { ... });
testWidgets('체크인 1개 이상이면 첫 체크인 미션 완료 표시', (tester) async { ... });
```

**GREEN**: MissionScreen에 habitListNotifierProvider + checkinsListProvider를 조합해
CheckMissionUseCase로 completedMissionIds 계산 → 미션 isCompleted 오버라이드.

**Step 5: 커밋**

```bash
git commit -m "feat: auto-detect mission completion in MissionScreen"
```

---

## Task 130: StatisticsScreen 습관별 달성률 표시 (TDD) ✅

현재 StatisticsScreen은 전체 합산만 표시. 습관별 달성률 리스트 추가.

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('습관별 달성률 표시', (tester) async { ... });
```

**GREEN**: ListView에 각 habit의 체크인 수 기반 달성률 Row 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: show per-habit completion rate in StatisticsScreen"
```

---

## Task 131: 알림 설정 저장 메시지 표시 (TDD) ✅

알림 설정 변경 후 "저장되었습니다" SnackBar 표시.

**Files:**

- Modify: `lib/presentation/screens/notification_settings_screen.dart`
- Modify: `test/widget/notification_settings_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('알림 토글 변경 시 저장 메시지 표시', (tester) async { ... });
```

**GREEN**: SwitchListTile onChanged에 ScaffoldMessenger.of(context).showSnackBar 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: show save confirmation snackbar in NotificationSettings"
```

---

## Task 132: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp mission stats complete"
```
