# Habit Rabbit MVP 알림 설정 영속성 — Implementation Plan

**Goal:** 앱 재시작 후에도 알림 설정(시간, 활성화 여부)을 유지

---

## Task 209: HiveNotificationRepository (TDD)

Hive Box에 NotificationSettings를 저장/로드.

**Files:**

- Create: `lib/data/repositories/hive_notification_repository.dart`
- Create: `test/unit/data/hive_notification_repository_test.dart`

**RED**: 테스트:

```dart
test('초기에는 기본 설정(9시 0분, 활성화) 반환', () { ... });
test('저장 후 로드하면 저장된 설정 반환', () { ... });
test('재생성 후에도 마지막 설정 복원', () { ... });
test('isEnabled false 저장 후 로드', () { ... });
```

**GREEN**: `HiveNotificationRepository(box)` — hour, minute, isEnabled를 Hive에 저장.

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveNotificationRepository for persistent notification settings"
```

---

## Task 210: main.dart에 알림 설정 영속성 연결

**Files:**

- Create: `lib/domain/repositories/notification_settings_repository.dart`
- Modify: `lib/presentation/providers/notification_provider.dart`
- Modify: `lib/main.dart`

**GREEN**:

- `NotificationSettingsRepository` 추상 인터페이스 추가
- `notificationSettingsProvider`를 `NotifierProvider`로 교체 (Hive에서 초기값 로드)
- main.dart에서 notificationBox 열기 + override 추가

**Step 5: 커밋**

```bash
git commit -m "feat: wire HiveNotificationRepository in main.dart for persistent alarm"
```

---

## Task 211: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp notification persistence complete"
```
