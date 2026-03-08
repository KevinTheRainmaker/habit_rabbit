# Habit Rabbit MVP 당근 포인트 영속성 — Implementation Plan

**Goal:** 앱 재시작 후에도 당근 포인트 잔액 유지 (체크인에서 합산)

---

## Task 188: TotalCarrotPointsUseCase (TDD)

체크인 목록에서 총 당근 포인트를 합산하는 유스케이스.

**Files:**

- Create: `lib/domain/usecases/total_carrot_points_usecase.dart`
- Create: `test/unit/domain/total_carrot_points_usecase_test.dart`

**RED**: 테스트:

```dart
test('빈 체크인 목록이면 0 반환', () { ... });
test('체크인별 carrotPoints 합산', () { ... });
```

**GREEN**: `TotalCarrotPointsUseCase(checkins).total` → int.

**Step 5: 커밋**

```bash
git commit -m "feat: add TotalCarrotPointsUseCase to sum points from checkins"
```

---

## Task 189: HabitListScreen 시작 시 포인트 초기화 (TDD)

기존 체크인에서 총 포인트를 계산해 `carrotPointsProvider`를 초기화.
새 체크인 시에는 기존대로 add().

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트: "기존 체크인이 있으면 당근 포인트 잔액을 합산해 표시"

**GREEN**: `HabitListScreen`에서 allCheckins 로드 후
`carrotPointsProvider.notifier.initialize(total)` 호출.

`CarrotPointsNotifier`에 `initialize(int)` 메서드 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: initialize carrot points from existing checkins on startup"
```

---

## Task 190: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp carrot persistence complete"
```
