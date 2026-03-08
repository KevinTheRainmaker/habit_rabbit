# Habit Rabbit MVP Premium Notifications — Implementation Plan

**Goal:** isPremium 알림 화면 연결 + 요일별 알림 UI + 심화 통계 섹션

---

## Task 158: NotificationSettingsScreen에 isPremium 전달 (TDD) ✅ 완료

HabitListScreen에서 NotificationSettingsScreen 라우트 시 user.isPremium 전달.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('알림 설정 화면에 isPremium 전달', (tester) async { ... });
```

**GREEN**: NotificationSettingsScreen() → NotificationSettingsScreen(isPremium: user.isPremium) 연결.

**Step 5: 커밋**

```bash
git commit -m "feat: pass isPremium to NotificationSettingsScreen"
```

---

## Task 159: 요일별 알림 시간 UI (유료 전용) (TDD) ✅ 완료

Story 16 AC: 유료 사용자에게 요일별 개별 알림 시간 설정 UI 표시.

**Files:**

- Modify: `lib/presentation/screens/notification_settings_screen.dart`
- Modify: `test/widget/notification_settings_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('유료 사용자에게 요일별 알림 시간 설정 목록 표시', (tester) async { ... });
```

**GREEN**: isPremium이면 월~일 각 요일별 ListTile 표시 (기본 시간 09:00).

**Step 5: 커밋**

```bash
git commit -m "feat: show per-day notification time UI for premium users"
```

---

## Task 160: 심화 통계 섹션 (유료 전용) (TDD) ✅ 완료

Story 18 AC: 유료 사용자에게 요일별 달성률 패턴 표시.

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('유료 사용자에게 요일별 달성률 패턴 섹션 표시', (tester) async { ... });
testWidgets('무료 사용자에게 요일별 달성률 패턴 섹션 미표시', (tester) async { ... });
```

**GREEN**: isPremium이면 "요일별 달성 패턴" 섹션 표시 (요일 이름 + 달성률).

**Step 5: 커밋**

```bash
git commit -m "feat: show per-day completion pattern for premium users"
```

---

## Task 161: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp premium notifications complete"
```
