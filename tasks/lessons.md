# Lessons Learned — Habit Rabbit

## Flutter 테스트 패턴

### 1. DateTime.now()는 tester.pump()로 페이크되지 않는다

`tester.pump(Duration(hours: 25))`는 dart:async Timer를 정상적으로 진행시키지만,
Timer 콜백 내부의 `DateTime.now()`는 OS 시스템 클록에서 직접 읽으므로 실제 시간을 반환한다.

**Fix:** Timer 콜백에서 `DateTime.now()` 대신 provider 상태를 사용:

```dart
// 나쁜 예 — 테스트 불가
_midnightTimer = Timer(untilMidnight, () {
  ref.read(currentDateProvider.notifier).state = DateTime.now(); // 테스트에서 페이크 안 됨
});

// 좋은 예 — 테스트 가능
_midnightTimer = Timer(untilMidnight, () {
  final current = ref.read(currentDateProvider);
  ref.read(currentDateProvider.notifier).state =
      DateTime(current.year, current.month, current.day + 1);
});
```

**원칙:** 시간/날짜 의존 로직은 항상 `currentDateProvider` 같은 Provider로 추상화할 것.

---

### 2. HapticFeedback은 try-catch 바깥에 두어야 한다

`HapticFeedback.mediumImpact()`를 try-catch 블록 안에 넣으면, 테스트 환경에서
플랫폼 채널이 없어 예외가 발생하고 catch가 이를 삼켜버려 그 아래의 `setState` 호출이 실행되지 않는다.

```dart
// 나쁜 예 — HapticFeedback 예외가 setState를 막음
try {
  await HapticFeedback.mediumImpact();
  setState(() { _checkedIn = true; }); // 실행 안 됨
} catch (_) {}

// 좋은 예 — setState 완료 후 fire-and-forget
try {
  setState(() { _checkedIn = true; });
  _autoCompleteMissions(streak);
} catch (_) {}
HapticFeedback.mediumImpact().ignore(); // try-catch 밖에서 .ignore()
```

**원칙:** 플랫폼 채널 호출(HapticFeedback, Clipboard 등)은 비즈니스 로직과 분리할 것.

---

### 3. 플랫폼 채널 Mocking (HapticFeedback 테스트)

HapticFeedback 등 플랫폼 채널 호출을 테스트에서 검증하려면:

```dart
final log = <MethodCall>[];
tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
  SystemChannels.platform,
  (call) async {
    log.add(call);
    return null;
  },
);

// ... 탭 후 ...

expect(
  log.any((call) =>
      call.method == 'HapticFeedback.vibrate' &&
      call.arguments == 'HapticFeedbackType.mediumImpact'),
  isTrue,
);
```

**주의:** 핸들러가 `null` 반환이 아닌 예외를 던지면 다른 시스템 채널 호출도 영향받을 수 있다.

---

### 4. 빈 상태(Empty State)는 데이터 파이프라인 단계별로 분기해야 한다

필터링이 여러 단계를 거치는 경우, 각 단계의 빈 상태를 명시적으로 구분:

```dart
// 나쁜 예 — 두 케이스를 동일하게 처리
if (habits.isEmpty) {
  return EmptyHabitState(onAdd: ...); // 오늘 습관이 없어도 "추가하기" 표시
}

// 좋은 예 — 단계별 분기
if (allHabits.isEmpty) {
  return EmptyHabitState(onAdd: ...); // 정말 습관이 없음
}
if (habits.isEmpty) {
  return RestDayState(); // 습관은 있지만 오늘 스케줄 없음
}
return HabitListBody(...);
```

---

### 5. mocktail clearInteractions() 타이밍

`clearInteractions(mockRepo)`는 검증하려는 액션 **직전**에 호출해야 한다.

```dart
// 올바른 패턴
await tester.pumpAndSettle(); // 초기 로드 (getHabits 1회 호출)
clearInteractions(mockHabit); // 이전 호출 카운트 리셋

await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
await tester.pumpAndSettle();

verify(() => mockHabit.getHabits(userId: 'uid-1')).called(1); // 리프레시만 카운트
```

---

### 6. RefreshIndicator + ListView 올바른 중첩 구조

```dart
// Expanded > RefreshIndicator > ListView 순서 필수
Expanded(
  child: RefreshIndicator(
    onRefresh: () async {
      ref.invalidate(habitListNotifierProvider(userId));
    },
    child: ListView.builder(...),
  ),
),
```

**테스트 패턴:**

```dart
await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
await tester.pumpAndSettle();
verify(() => mockRepo.getHabits()).called(1);
```
