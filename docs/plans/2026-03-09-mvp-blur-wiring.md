# Habit Rabbit MVP Blur Wiring & Onboarding Skip — Implementation Plan

**Goal:** PremiumBlurOverlay 통계 화면 연결 + 온보딩 스킵 + 알림 세분화 게이트

---

## Task 154: StatisticsScreen에 PremiumBlurOverlay 연결 (TDD) ✅ 완료

Story 19 AC: 심화 통계 영역에 블러 오버레이 실제 적용 (위젯은 이미 생성됨, 화면 연결 미완료).

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자 통계 화면에 PremiumBlurOverlay 표시', (tester) async { ... });
```

**GREEN**: StatisticsScreen의 습관별 달성률 섹션을 PremiumBlurOverlay로 감싸기.

**Step 5: 커밋**

```bash
git commit -m "feat: wire PremiumBlurOverlay into StatisticsScreen"
```

---

## Task 155: 온보딩 스킵 옵션 (TDD) ✅ 완료 (이미 구현됨)

Story 28 AC: 온보딩 화면에 "건너뛰기" 옵션 제공. 스킵 시 빈 습관 목록으로 바로 진입.

**Files:**

- Modify: `lib/presentation/screens/onboarding_screen.dart`
- Modify: `test/widget/onboarding_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('온보딩 화면에 건너뛰기 버튼 표시', (tester) async { ... });
testWidgets('건너뛰기 탭 시 onSkip 콜백 호출', (tester) async { ... });
```

**GREEN**: AppBar action 또는 TextButton으로 "건너뛰기" 추가, `onSkip` 콜백 노출.

**Step 5: 커밋**

```bash
git commit -m "feat: add skip option to onboarding screen"
```

---

## Task 156: 알림 세분화 프리미엄 게이트 (TDD) ✅

Story 16 AC: 무료 사용자가 요일별 알림 세분화 진입 시 유료 안내 표시.

**Files:**

- Modify: `lib/presentation/screens/notification_settings_screen.dart`
- Modify: `test/widget/notification_settings_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자에게 요일별 알림 세분화 프리미엄 안내 표시', (tester) async { ... });
testWidgets('유료 사용자에게 요일별 알림 세분화 UI 표시', (tester) async { ... });
```

**GREEN**: `isPremium` prop 추가, 무료 사용자에게 "유료 전용 기능이에요" ListTile + 자물쇠 아이콘 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: add premium gate to per-day notification settings"
```

---

## Task 157: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp blur wiring complete"
```
