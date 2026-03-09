# Habit Rabbit MVP 앱 재개 날짜 갱신 — Implementation Plan

**Goal:** 앱이 자정 이후 백그라운드에서 재개될 때 "오늘" 날짜를 자동 갱신

현재 문제:

- `HabitListScreen`에서 `DateTime.now()`를 build 시점에만 평가
- 사용자가 앱을 자정 이전에 열고 다음날 재개하면 어제의 날짜로 습관 필터링됨
- 체크인 상태도 어제 날짜 기준으로 표시됨

---

## ✅ Task 224: currentDateProvider 추가 + HabitListScreen 연결 (TDD)

**Files:**

- Create: `lib/presentation/providers/date_provider.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Create: `test/unit/presentation/date_provider_test.dart`

**RED**: 테스트 추가:

```dart
test('currentDateProvider는 DateTime을 반환한다', () { ... });
test('currentDateProvider override 시 지정한 날짜 반환', () { ... });
```

**GREEN**:

- `currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now())`
- `HabitListScreen`에서 `DateTime.now()` 대신 `ref.watch(currentDateProvider)` 사용
- `CheckinProvider` 관련 날짜 참조도 `currentDateProvider` 활용

**Step 5: 커밋**

```bash
git commit -m "feat: add currentDateProvider for testable date injection"
```

---

## ✅ Task 225: WidgetsBindingObserver로 앱 재개 시 날짜 갱신 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트 추가:

```dart
testWidgets('날짜가 변경되면 오늘 습관 목록이 갱신됨', (tester) async { ... });
```

**GREEN**:

- `_HabitListScreenState`에 `WidgetsBindingObserver` mixin 추가
- `didChangeAppLifecycleState`에서 `AppLifecycleState.resumed` 시:
  - `ref.read(currentDateProvider.notifier).state = DateTime.now()` 호출
- `initState`에서 `WidgetsBinding.instance.addObserver(this)` 등록
- `dispose`에서 `removeObserver(this)` 해제

**Step 5: 커밋**

```bash
git commit -m "feat: refresh date on app resume via WidgetsBindingObserver"
```

---

## ✅ Task 226: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp date refresh complete"
```
