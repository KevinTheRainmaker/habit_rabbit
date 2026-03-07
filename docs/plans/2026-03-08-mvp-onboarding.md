# Habit Rabbit MVP Onboarding — Implementation Plan

**Goal:** 온보딩 퀴즈 + 로그인 화면 + 앱 진입 흐름 연결

---

## Task 68: OnboardingScreen 위젯 (TDD) ✅

3단계 온보딩 퀴즈 화면. 목표 유형, 루틴 시간대, 습관 추천.

**Files:**

- Create: `lib/presentation/screens/onboarding_screen.dart`
- Create: `test/widget/onboarding_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('온보딩 첫 질문 표시', (tester) async { ... });
testWidgets('답변 선택 후 다음 질문으로 이동', (tester) async { ... });
testWidgets('마지막 질문 완료 시 콜백 호출', (tester) async { ... });
testWidgets('건너뛰기 버튼 존재', (tester) async { ... });
```

**GREEN**: OnboardingScreen 구현:

- PageView 기반 3단계 퀴즈
- 각 페이지: 질문 + 선택지 ListTile
- 마지막 페이지 완료 시 `onCompleted(List<String> answers)` 콜백
- 상단에 '건너뛰기' TextButton

**Step 5: 커밋**

```bash
git commit -m "feat: add OnboardingScreen"
```

---

## Task 69: HabitRecommendationScreen 위젯 (TDD) ✅

온보딩 결과 기반 습관 추천 화면.

**Files:**

- Create: `lib/presentation/screens/habit_recommendation_screen.dart`
- Create: `test/widget/habit_recommendation_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('추천 습관 목록 표시', (tester) async { ... });
testWidgets('습관 선택/해제 토글', (tester) async { ... });
testWidgets('시작하기 버튼으로 선택된 습관 저장', (tester) async { ... });
```

**GREEN**: HabitRecommendationScreen 구현:

- 3개 추천 습관 CheckboxListTile로 표시
- 선택된 습관들 → `onStart(List<String> selectedHabits)` 콜백
- '직접 입력할게요' 옵션 (빈 선택으로 진행)

**Step 5: 커밋**

```bash
git commit -m "feat: add HabitRecommendationScreen"
```

---

## Task 70: LoginScreen 위젯 (TDD) ✅

앱 진입 시 보이는 로그인 화면 (게스트 모드 포함).

**Files:**

- Create: `lib/presentation/screens/login_screen.dart`
- Create: `test/widget/login_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('앱 타이틀 표시', (tester) async { ... });
testWidgets('게스트로 시작 버튼 존재', (tester) async { ... });
testWidgets('게스트 버튼 탭 시 onGuestLogin 콜백 호출', (tester) async { ... });
```

**GREEN**: LoginScreen 구현:

- 앱 이름 + 토끼 로고 (이모지 대체)
- '게스트로 시작' ElevatedButton → `onGuestLogin()` 콜백
- (추후 Apple/Google 로그인 확장 예정)

**Step 5: 커밋**

```bash
git commit -m "feat: add LoginScreen"
```

---

## Task 71: 앱 진입 흐름 연결 (TDD) ✅

첫 실행 → LoginScreen → OnboardingScreen → HabitListScreen.

**Files:**

- Create: `lib/presentation/screens/app_router.dart`
- Create: `test/widget/app_router_test.dart`

**RED**: 테스트:

```dart
testWidgets('비로그인 상태에서 LoginScreen 표시', (tester) async { ... });
testWidgets('게스트 로그인 후 OnboardingScreen 표시', (tester) async { ... });
testWidgets('온보딩 완료 후 HabitListScreen 표시', (tester) async { ... });
testWidgets('온보딩 건너뛰기 시 HabitListScreen 표시', (tester) async { ... });
```

**GREEN**: AppRouter 구현:

- `currentUserProvider` 감시 → null이면 LoginScreen
- 로그인 완료 → SharedPreferences로 온보딩 완료 여부 체크
- 온보딩 미완료 → OnboardingScreen → HabitRecommendationScreen → HabitListScreen
- 온보딩 완료 → HabitListScreen 직행

**Step 5: 커밋**

```bash
git commit -m "feat: wire onboarding flow in AppRouter"
```

---

## Task 72: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: onboarding flow complete"
```
