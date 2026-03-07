# Habit Rabbit MVP Notification Settings + Today Filter — Implementation Plan

**Goal:** 오늘의 습관 필터링 + 알림 설정 도메인 레이어

---

## Task 58: Habit 요일 필드 추가 (TDD)

Habit 엔티티에 `targetDays` (List<int>, 0=월~6=일) 필드 추가.

**Files:**

- Modify: `lib/domain/entities/habit.dart`
- Modify: `test/unit/domain/habit_test.dart`

**RED**: 테스트:

```dart
test('targetDays 기본값은 매일 (0~6)', () {
  final habit = Habit(id: 'h-1', ...);
  expect(habit.targetDays, equals([0, 1, 2, 3, 4, 5, 6]));
});
test('특정 요일만 설정 가능', () {
  final habit = Habit(id: 'h-1', targetDays: [1, 3, 5], ...);
  expect(habit.targetDays, equals([1, 3, 5]));
});
```

**GREEN**: Habit에 `targetDays` 필드 추가 (기본값 매일).

**Step 5: 커밋**

```bash
git commit -m "feat: add targetDays field to Habit entity"
```

---

## Task 59: TodayHabitsUseCase (TDD)

오늘 요일에 해당하는 습관만 필터링.

**Files:**

- Create: `lib/domain/usecases/today_habits_usecase.dart`
- Create: `test/unit/domain/today_habits_usecase_test.dart`

**RED**: 테스트:

```dart
test('오늘 요일에 해당하는 습관만 반환', () {
  // 월요일(1)이면 targetDays에 1이 포함된 습관만 반환
});
test('매일 설정된 습관은 항상 반환', () { ... });
test('오늘 요일이 없는 습관은 제외', () { ... });
```

**GREEN**: TodayHabitsUseCase 구현.

**Step 5: 커밋**

```bash
git commit -m "feat: add TodayHabitsUseCase"
```

---

## Task 60: HabitListScreen 오늘 필터 적용 (TDD)

HabitListScreen에 TodayHabitsUseCase 적용.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('오늘 요일이 아닌 습관은 목록에서 숨김', (tester) async {
  // 월요일에 화~일 설정 습관 → 목록에 없음
});
```

**GREEN**: `habitListNotifierProvider` 데이터를 `TodayHabitsUseCase`로 필터링.

**Step 5: 커밋**

```bash
git commit -m "feat: filter habits by today's day of week"
```

---

## Task 61: NotificationSettings 엔티티 (TDD)

알림 시간/요일 설정 엔티티.

**Files:**

- Create: `lib/domain/entities/notification_settings.dart`
- Create: `test/unit/domain/notification_settings_test.dart`

**RED**: 테스트:

```dart
test('기본 알림 시간은 오전 9시', () {
  final settings = NotificationSettings.defaultSettings();
  expect(settings.hour, equals(9));
  expect(settings.minute, equals(0));
});
test('같은 설정은 동일하다', () { ... });
```

**GREEN**: NotificationSettings 엔티티 구현 (Equatable).

**Step 5: 커밋**

```bash
git commit -m "feat: add NotificationSettings entity"
```

---

## Task 62: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: today filter + notification settings complete"
```
