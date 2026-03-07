# Habit Rabbit MVP Auth & Providers — Implementation Plan

**Goal:** 인증 유스케이스 + InMemoryAuthRepository + Riverpod Provider 완성

---

## Task 16: InMemoryAuthRepository (TDD)

**Files:**

- Create: `lib/data/repositories/in_memory_auth_repository.dart`
- Create: `test/unit/data/in_memory_auth_repository_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add InMemoryAuthRepository for dev/test use"
```

---

## Task 17: Auth 유스케이스 (TDD)

**Files:**

- Create: `lib/domain/usecases/sign_in_usecase.dart`
- Create: `lib/domain/usecases/sign_out_usecase.dart`
- Create: `test/unit/domain/sign_in_usecase_test.dart`
- Create: `test/unit/domain/sign_out_usecase_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add SignIn/SignOut use cases"
```

---

## Task 18: Auth Riverpod Provider (TDD)

**Files:**

- Create: `lib/presentation/providers/auth_provider.dart`
- Create: `test/unit/presentation/auth_provider_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add Riverpod auth provider"
```

---

## Task 19: CheckIn Riverpod Provider (TDD)

**Files:**

- Create: `lib/presentation/providers/checkin_provider.dart`
- Create: `test/unit/presentation/checkin_provider_test.dart`

**Step 5: 커밋**

```bash
git commit -m "feat: add Riverpod checkin provider"
```

---

## Task 20: 전체 테스트 통과 확인

```bash
flutter test test/unit/
```

```bash
git commit -m "chore: auth and provider layer complete"
```
