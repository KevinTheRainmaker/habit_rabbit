# Habit Rabbit MVP Notification & Teaser Polish — Implementation Plan

**Goal:** 알림 토끼 언어 + 심화 통계 블러 티저

---

## Task 151: 알림 텍스트에 토끼 언어 표시 (TDD) ✅

Story 15 AC: 알림 텍스트에 토끼 캐릭터 언어 사용 ("당근이 기다리고 있어요!").

**Files:**

- Modify: `lib/presentation/screens/notification_settings_screen.dart`
- Modify: `test/widget/notification_settings_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('알림 설정 화면에 토끼 알림 문구 표시', (tester) async { ... });
```

**GREEN**: 화면에 "당근이 기다리고 있어요!" 안내 텍스트 추가.

**Step 5: 커밋**

```bash
git commit -m "feat: add rabbit character text to notification settings"
```

---

## Task 152: StatisticsScreen 유료 기능 블러 티저 (TDD) ✅

Story 19 AC: 무료 사용자에게 블러 오버레이 + "구독하면 이런 인사이트를" 카피.

**Files:**

- Create: `lib/presentation/widgets/premium_blur_overlay.dart`
- Modify: `lib/presentation/screens/statistics_screen.dart`
- Create: `test/widget/premium_blur_overlay_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자에게 블러 오버레이 + 업그레이드 CTA 표시', (tester) async { ... });
testWidgets('유료 사용자에게 블러 오버레이 미표시', (tester) async { ... });
```

**GREEN**: Stack + BackdropFilter(ImageFilter.blur) + 업그레이드 버튼 오버레이.

**Step 5: 커밋**

```bash
git commit -m "feat: add premium blur teaser overlay to StatisticsScreen"
```

---

## Task 153: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp notification teaser complete"
```
