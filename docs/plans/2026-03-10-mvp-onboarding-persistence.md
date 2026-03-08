# Habit Rabbit MVP 온보딩 영속성 — Implementation Plan

**Goal:** 앱 재시작 후 온보딩 완료 여부를 유지 (한 번 완료하면 다시 안 보임)

---

## Task 212: HiveOnboardingRepository (TDD)

Hive Box에 온보딩 완료 플래그 저장/로드.

**Files:**

- Create: `lib/data/repositories/hive_onboarding_repository.dart`
- Create: `test/unit/data/hive_onboarding_repository_test.dart`

**RED**: 테스트:

```dart
test('초기에는 완료되지 않음(false) 반환', () { ... });
test('완료 저장 후 true 반환', () { ... });
test('재생성 후에도 완료 상태 복원', () { ... });
test('reset 후 false 반환', () { ... });
```

**GREEN**: `HiveOnboardingRepository(box)` — isCompleted 불리언을 Hive에 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveOnboardingRepository for persistent onboarding state"
```

---

## Task 213: main.dart에 온보딩 영속성 연결

**Files:**

- Modify: `lib/main.dart`

**GREEN**: onboardingBox 열기, 초기값 로드, `onboardingCompletedNotifierProvider.overrideWith` + ref.listen으로 변경 시 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: wire HiveOnboardingRepository in main.dart for persistent onboarding"
```

---

## Task 214: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp onboarding persistence complete"
```
