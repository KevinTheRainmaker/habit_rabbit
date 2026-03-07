# Habit Rabbit MVP Delete Habit + Hive Persistence — Implementation Plan

**Goal:** 습관 삭제 UI + Hive 로컬 영속성

---

## Task 39: DeleteHabit Notifier 메서드 (TDD)

HabitListNotifier에 deleteHabit 메서드 추가.

**Files:**

- Modify: `lib/presentation/providers/habit_provider.dart`
- Modify: `test/unit/presentation/habit_list_notifier_test.dart`

**RED**: `test/unit/presentation/habit_list_notifier_test.dart`에 테스트 추가:

```dart
test('deleteHabit: 목록에서 습관 제거', () async {
  final habit = Habit(id: 'h-1', userId: 'uid-1', name: '운동',
      createdAt: DateTime(2026, 3, 7), isActive: true);
  when(() => mockRepo.getHabits(userId: 'uid-1'))
      .thenAnswer((_) async => [habit]);
  when(() => mockRepo.deleteHabit('h-1')).thenAnswer((_) async {});
  // ... setup container
  await container.read(habitListNotifierProvider('uid-1').future);
  await container.read(habitListNotifierProvider('uid-1').notifier)
      .deleteHabit('h-1');
  final habits = await container.read(habitListNotifierProvider('uid-1').future);
  expect(habits, isEmpty);
});
```

**GREEN**: `HabitListNotifier`에 deleteHabit 추가:

```dart
Future<void> deleteHabit(String habitId) async {
  final repo = ref.read(habitRepositoryProvider);
  await repo.deleteHabit(habitId);
  final current = state.valueOrNull ?? [];
  state = AsyncData(current.where((h) => h.id != habitId).toList());
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: add deleteHabit to HabitListNotifier"
```

---

## Task 40: 스와이프 삭제 UI (TDD)

HabitListScreen의 \_HabitTile에 스와이프-투-삭제 기능 추가.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: `test/widget/habit_list_screen_test.dart`에 테스트 추가:

```dart
testWidgets('습관 타일 스와이프로 삭제', (tester) async {
  // 습관 목록 + deleteHabit mock 설정 후
  // Dismissible 스와이프 → 목록에서 제거 확인
  await tester.drag(find.text('매일 운동'), const Offset(-500, 0));
  await tester.pumpAndSettle();
  expect(find.text('매일 운동'), findsNothing);
});
```

**GREEN**: `_HabitTile`을 `Dismissible`로 감싸기:

```dart
Dismissible(
  key: Key(widget.habit.id),
  direction: DismissDirection.endToStart,
  background: Container(color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 16),
    child: const Icon(Icons.delete, color: Colors.white)),
  onDismissed: (_) => ref
      .read(habitListNotifierProvider(widget.userId).notifier)
      .deleteHabit(widget.habit.id),
  child: ListTile(...),
)
```

**Step 5: 커밋**

```bash
git commit -m "feat: swipe-to-delete habit"
```

---

## Task 41: HiveHabitRepository (TDD)

InMemoryHabitRepository를 Hive 기반으로 교체.

**Files:**

- Create: `lib/data/repositories/hive_habit_repository.dart`
- Create: `test/unit/data/hive_habit_repository_test.dart`

**RED**: 테스트 작성:

```dart
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late Box box;
  setUp(() async {
    final dir = await Directory.systemTemp.createTemp();
    Hive.init(dir.path);
    box = await Hive.openBox('habits_test_${DateTime.now().millisecondsSinceEpoch}');
  });
  tearDown(() async { await box.deleteFromDisk(); });

  group('HiveHabitRepository', () {
    test('처음에는 습관 목록이 비어 있다', () async {
      final repo = HiveHabitRepository(box);
      final habits = await repo.getHabits(userId: 'uid-1');
      expect(habits, isEmpty);
    });
    test('addHabit: 추가 후 목록에 포함', () async { ... });
    test('deleteHabit: 삭제 후 목록에서 제거', () async { ... });
    test('checkIn: 체크인 후 Checkin 반환', () async { ... });
    test('checkIn: 중복 시 예외', () async { ... });
  });
}
```

**GREEN**: `HiveHabitRepository` 구현 (Map으로 직렬화):

```dart
class HiveHabitRepository implements HabitRepository {
  final Box _box;
  HiveHabitRepository(this._box);

  String _habitKey(String habitId) => 'habit_$habitId';
  String _checkinKey(String habitId, String userId, DateTime date) =>
      'checkin_${habitId}_${userId}_${date.toIso8601String().split('T').first}';

  @override
  Future<List<Habit>> getHabits({required String userId}) async {
    return _box.values
        .where((v) => v is Map && v['type'] == 'habit' && v['userId'] == userId)
        .map((v) => _habitFromMap(Map<String, dynamic>.from(v as Map)))
        .toList();
  }
  // ... 나머지 메서드
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: add HiveHabitRepository"
```

---

## Task 42: Provider에서 HiveHabitRepository 사용

**Files:**

- Modify: `lib/presentation/providers/habit_provider.dart`
- Modify: `lib/main.dart`

**Step 1**: `main.dart`에 Hive 초기화:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final habitBox = await Hive.openBox('habits');
  runApp(ProviderScope(
    overrides: [
      habitRepositoryProvider.overrideWithValue(HiveHabitRepository(habitBox)),
    ],
    child: const HabitRabbitApp(),
  ));
}
```

**Step 2**: `habit_provider.dart`에서 기본값 유지 (테스트는 override 사용):

```dart
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  throw UnimplementedError('habitRepositoryProvider must be overridden');
});
```

> 참고: 기존 InMemoryHabitRepository는 테스트 override로만 사용.

**Step 3**: 테스트가 여전히 override 사용하므로 변경 없음.

**Step 4**: `flutter test test/unit/ test/widget/` 전체 통과 확인.

**Step 5: 커밋**

```bash
git commit -m "feat: use HiveHabitRepository in production"
```

---

## Task 43: 전체 테스트 통과 확인

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: delete habit + hive persistence complete"
```
