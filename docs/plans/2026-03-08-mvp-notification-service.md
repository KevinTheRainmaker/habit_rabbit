# Habit Rabbit MVP Notification Service + UI — Implementation Plan

**Goal:** 알림 서비스 추상화 + NotificationSettingsScreen 구현

---

## Task 73: NotificationService 인터페이스 (TDD) ✅

알림 스케줄링 추상화. 실제 OS 알림은 추후 연동.

**Files:**

- Create: `lib/domain/services/notification_service.dart`
- Create: `test/unit/domain/notification_service_test.dart`

**RED**: 테스트:

```dart
test('InMemoryNotificationService는 NotificationService를 구현한다', () {
  final service = InMemoryNotificationService();
  expect(service, isA<NotificationService>());
});
test('알림 예약 후 예약 목록에 포함', () async { ... });
test('알림 취소 후 예약 목록에서 제거', () async { ... });
```

**GREEN**: NotificationService 인터페이스 + InMemoryNotificationService 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add NotificationService interface and InMemory impl"
```

---

## Task 74: notificationServiceProvider (TDD) ✅

Riverpod Provider로 NotificationService 제공.

**Files:**

- Create: `lib/presentation/providers/notification_provider.dart`
- Create: `test/unit/domain/notification_provider_test.dart`

**RED**: 테스트:

```dart
test('notificationServiceProvider는 NotificationService를 반환한다', () {
  final container = ProviderContainer();
  final service = container.read(notificationServiceProvider);
  expect(service, isA<NotificationService>());
});
test('notificationSettingsProvider 기본값은 defaultSettings', () { ... });
```

**GREEN**: notificationServiceProvider + notificationSettingsProvider(StateProvider) 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add notificationServiceProvider"
```

---

## Task 75: NotificationSettingsScreen 위젯 (TDD) ✅

알림 시간 및 활성화 여부 설정 화면.

**Files:**

- Create: `lib/presentation/screens/notification_settings_screen.dart`
- Create: `test/widget/notification_settings_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('알림 활성화 토글 표시', (tester) async { ... });
testWidgets('현재 알림 시간 표시', (tester) async { ... });
testWidgets('토글 변경 시 설정 업데이트', (tester) async { ... });
```

**GREEN**: NotificationSettingsScreen 구현:

- Switch 위젯으로 알림 활성화/비활성화
- 시간 표시 (HH:MM 형식)
- showTimePicker로 시간 선택

**Step 5: 커밋**

```bash
git commit -m "feat: add NotificationSettingsScreen"
```

---

## Task 76: HabitListScreen 설정 버튼 연결 (TDD) ✅

앱바에 설정 아이콘 버튼 → NotificationSettingsScreen 이동.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('설정 아이콘 탭 시 NotificationSettingsScreen으로 이동', (tester) async {
  // AppBar의 설정 아이콘 → 탭 → NotificationSettingsScreen
});
```

**GREEN**: AppBar actions에 settings 아이콘 버튼 추가, Navigator.push.

**Step 5: 커밋**

```bash
git commit -m "feat: navigate to NotificationSettingsScreen from AppBar"
```

---

## Task 77: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: notification service complete"
```
