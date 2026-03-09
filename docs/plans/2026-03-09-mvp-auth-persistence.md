# Habit Rabbit MVP 인증 영속성 — Implementation Plan

**Goal:** 앱 재시작 후 자동 로그인 (Hive에 마지막 사용자 저장)

---

## Task 206: HiveAuthRepository (TDD) ✅

Hive Box에 마지막 로그인 사용자 정보를 저장해 재시작 시 자동 복원.

**Files:**

- Create: `lib/data/repositories/hive_auth_repository.dart`
- Create: `test/unit/data/hive_auth_repository_test.dart`

**RED**: 테스트:

```dart
test('초기에는 currentUser가 null', () { ... });
test('signInAsGuest 후 currentUser에서 guest 유저 반환', () { ... });
test('signOut 후 currentUser가 null', () { ... });
test('재생성 후에도 마지막 로그인 유저 복원', () { ... });
```

**GREEN**: `HiveAuthRepository(box)` — userId, email, isPremium을 Hive에 저장.
재시작 시 저장된 사용자로 currentUser stream 초기화.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveAuthRepository for persistent login session"
```

---

## Task 207: main.dart에 HiveAuthRepository 연결 ✅

**Files:**

- Modify: `lib/main.dart`

**GREEN**: authBox 열기 + authRepositoryProvider.overrideWithValue 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: wire HiveAuthRepository in main.dart for auto-login"
```

---

## Task 208: 전체 테스트 통과 확인 ✅

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp auth persistence complete"
```
