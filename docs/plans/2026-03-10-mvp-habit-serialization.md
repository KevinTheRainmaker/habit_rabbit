# Habit Rabbit MVP 습관 직렬화 수정 — Implementation Plan

**Goal:** HiveHabitRepository에서 targetDays, icon, carrotPoints 필드 누락 버그 수정

현재 문제:

- `_habitToMap` / `_habitFromMap`에 `targetDays`, `icon` 필드 없음
- 앱 재시작 시 커스텀 요일 설정과 아이콘이 사라짐
- `_checkinToMap` / `_checkinFromMap`에 `carrotPoints` 필드 없음
- 재시작 후 당근 포인트 합산이 항상 0

---

## Task 217: HiveHabitRepository 직렬화 버그 수정 (TDD)

**Files:**

- Modify: `test/unit/data/hive_habit_repository_test.dart`
- Modify: `lib/data/repositories/hive_habit_repository.dart`

**RED**: 누락 필드 검증 테스트 추가:

```dart
test('targetDays와 icon이 저장 후 복원됨', () { ... });
test('carrotPoints가 체크인 저장 후 복원됨', () { ... });
```

**GREEN**: `_habitToMap`에 targetDays, icon 추가; `_habitFromMap`에서 복원.
`_checkinToMap`에 carrotPoints 추가; `_checkinFromMap`에서 복원.

**Step 5: 커밋**

```bash
git commit -m "fix: serialize targetDays, icon, carrotPoints in HiveHabitRepository"
```

---

## Task 218: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp habit serialization fix complete"
```
