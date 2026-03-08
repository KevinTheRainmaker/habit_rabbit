# Habit Rabbit MVP 라우터 연결 — Implementation Plan

**Goal:** AppRouter를 실제 앱 진입점으로 연결 (온보딩 → 로그인 → 메인 흐름 완성)

현재 문제:

- main.dart의 `_AuthGate`는 온보딩 체크 없이 바로 HabitListScreen으로 이동
- `AppRouter`는 올바른 흐름(로그인→온보딩→메인)을 가지지만 사용되지 않음

---

## Task 215: AppRouter를 앱 진입점으로 연결

**Files:**

- Modify: `lib/main.dart`

**GREEN**:

- `HabitRabbitApp.build`에서 `home: const _AuthGate()` → `home: const AppRouter()`로 변경
- `_AuthGate` 클래스 제거
- `AppRouter` import 추가

**Step 5: 커밋**

```bash
git commit -m "fix: wire AppRouter as home to enable onboarding flow"
```

---

## Task 216: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp router wiring complete"
```
