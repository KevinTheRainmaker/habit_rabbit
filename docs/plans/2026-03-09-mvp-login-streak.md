# Habit Rabbit MVP 로그인 연결 & 현재 스트릭 — Implementation Plan

**Goal:** 게스트/소셜 로그인 실제 연결 + 현재 스트릭 계산 및 연동

---

## Task 173: AuthRepository signInAsGuest + LoginScreen 연결 (TDD)

Story 24 AC: 비로그인 상태에서도 로컬 데이터로 앱 사용 가능.
게스트로 시작, Google, Apple 버튼 모두 실제 동작.

**Files:**

- Modify: `lib/domain/repositories/auth_repository.dart`
- Modify: `lib/data/repositories/in_memory_auth_repository.dart`
- Modify: `lib/presentation/screens/login_screen.dart`
- Modify: `lib/presentation/screens/app_router.dart`
- Modify: `test/widget/login_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('게스트로 시작 버튼 탭 시 onGuestLogin 콜백 호출', (tester) async { ... });
```

**GREEN**:

1. `AuthRepository`에 `signInAsGuest()` 추가
2. `InMemoryAuthRepository`에 구현 (guest user 반환)
3. `AppRouter.onGuestLogin`에서 `authRepository.signInAsGuest()` 호출
4. LoginScreen Google/Apple 버튼도 실제 호출 연결

**Step 5: 커밋**

```bash
git commit -m "feat: wire guest and social login buttons in LoginScreen"
```

---

## Task 174: CurrentStreakUseCase + CompletionRateCard 연결 (TDD)

Story 4 AC: CompletionRateCard에 현재 스트릭 정보를 실제로 전달.

**Files:**

- Create: `lib/domain/usecases/current_streak_usecase.dart`
- Create: `test/unit/domain/current_streak_usecase_test.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
test('오늘 체크인 있으면 현재 스트릭 1 이상', () { ... });
test('어제 이후 체크인 없으면 스트릭 0', () { ... });
```

**GREEN**: `CurrentStreakUseCase(checkins, today).currentStreak` → int.
HabitListScreen의 CompletionRateCard에 `currentStreak` 전달.

**Step 5: 커밋**

```bash
git commit -m "feat: add CurrentStreakUseCase and wire to CompletionRateCard"
```

---

## Task 175: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp login streak complete"
```
