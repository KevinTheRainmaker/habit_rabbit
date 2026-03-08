# Habit Rabbit MVP 클린업 — Implementation Plan

**Goal:** 분석 오류 수정, 경고 제거, 전체 테스트 그린 유지

---

## Task 182: widget_test.dart 스모크 테스트 수정

기본 Flutter 생성 테스트가 `MyApp` 참조 (실제 클래스는 `HabitRabbitApp`).
카운터 앱 로직을 HabitRabbitApp 연기 테스트로 교체.

**Files:**

- Modify: `test/widget_test.dart`

**RED**: 현재 `flutter test test/widget_test.dart` → 실패 (MyApp 미존재)

**GREEN**: widget_test.dart를 HabitRabbitApp 기반 smoke test로 교체.

**Step 5: 커밋**

```bash
git commit -m "fix: replace generated smoke test with HabitRabbitApp widget test"
```

---

## Task 183: 미사용 import 경고 제거

`flutter analyze`에서 발견된 미사용 import 2건 제거.

**Files:**

- Modify: `test/widget/auth_routing_test.dart`
- Modify: `test/widget/notification_settings_screen_test.dart`

**RED**: `flutter analyze` → warning 2건 존재

**GREEN**: 해당 import 라인 제거.

**Step 5: 커밋**

```bash
git commit -m "chore: remove unused imports from test files"
```

---

## Task 184: 전체 테스트 + 분석 클린 통과 확인 ✅

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp cleanup complete"
```
