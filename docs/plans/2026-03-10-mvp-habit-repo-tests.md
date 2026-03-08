# Habit Rabbit MVP HiveHabitRepository 누락 테스트 — Implementation Plan

**Goal:** getCheckins, 체크인 영속성, 연쇄 삭제 시나리오 검증

누락 테스트:

- `getCheckins` 반환값 검증
- 체크인 저장 후 재생성 시 복원 (영속성)
- 습관 삭제 시 관련 체크인도 삭제 (연쇄 삭제)
- 7일 스트릭 보너스 포인트 (streakDay=6 → 15포인트)

---

## Task 219: HiveHabitRepository 누락 테스트 추가 (TDD)

**Files:**

- Modify: `test/unit/data/hive_habit_repository_test.dart`

**RED**: 누락 시나리오 테스트 추가.

**GREEN**: 코드 변경 없이 모두 통과해야 함 (또는 버그 발견 시 수정).

**Step 5: 커밋**

```bash
git commit -m "test: add missing getCheckins and cascading delete tests"
```

---

## Task 220: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp habit repo tests complete"
```
