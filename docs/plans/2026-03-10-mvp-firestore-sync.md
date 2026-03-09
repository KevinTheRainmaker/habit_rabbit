# Story 25: Firestore 데이터 동기화 — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Hive 로컬 저장소를 유지하면서 Firestore를 통한 크로스 디바이스 데이터 동기화 구현

**Architecture:**

- **오프라인 우선**: Hive가 항상 primary store (오프라인에서도 동작)
- **Write-through**: 쓰기 → Hive 즉시 + Firestore 비동기(best-effort)
- **Sync-down**: 앱 시작 시 Firestore → Hive 데이터 머지
- **범위**: Habit + Checkin 동기화 (샵/복구권은 Phase 2)

**Firestore 구조:**

```
/users/{userId}/habits/{habitId}     → Habit 데이터
/users/{userId}/checkins/{checkinId} → Checkin 데이터
```

**Tech Stack:** cloud_firestore ^5.2.1, fake_cloud_firestore ^3.0.0 (테스트용)

---

## Task 259: cloud_firestore 패키지 추가

**Files:**

- Modify: `pubspec.yaml`

**Step 1: pubspec.yaml 수정**

`cloud_firestore` 주석 해제:

```yaml
# 기타 — 외부 설정 완료 후 주석 해제
cloud_firestore: ^5.2.1 # 주석 해제
```

`fake_cloud_firestore`를 dev_dependencies에 추가:

```yaml
dev_dependencies:
  fake_cloud_firestore: ^3.0.0 # 추가
```

**Step 2: 패키지 설치**

```bash
flutter pub get
```

**Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: enable cloud_firestore and fake_cloud_firestore"
```

---

## Task 260: FirestoreHabitRepository (TDD)

**Files:**

- Create: `lib/data/repositories/firestore_habit_repository.dart`
- Create: `test/unit/data/firestore_habit_repository_test.dart`

**Step 1: RED — 테스트 작성**

```dart
// test/unit/data/firestore_habit_repository_test.dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/firestore_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

Habit makeHabit({String id = 'h1', String userId = 'u1', String name = '운동'}) =>
    Habit(
      id: id,
      userId: userId,
      name: name,
      createdAt: DateTime(2026, 1, 1),
      isActive: true,
    );

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreHabitRepository repo;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repo = FirestoreHabitRepository(firestore: fakeFirestore);
  });

  group('FirestoreHabitRepository', () {
    group('getHabits', () {
      test('초기에는 빈 목록 반환', () async {
        final habits = await repo.getHabits(userId: 'u1');
        expect(habits, isEmpty);
      });

      test('addHabit 후 getHabits에서 반환', () async {
        final habit = makeHabit();
        await repo.addHabit(habit);
        final habits = await repo.getHabits(userId: 'u1');
        expect(habits.length, 1);
        expect(habits.first.name, '운동');
      });

      test('isActive=false 습관은 getHabits에서 제외', () async {
        final habit = makeHabit().copyWith(isActive: false);
        await repo.addHabit(habit);
        final habits = await repo.getHabits(userId: 'u1');
        expect(habits, isEmpty);
      });

      test('다른 userId의 습관은 반환하지 않음', () async {
        await repo.addHabit(makeHabit(userId: 'u2'));
        final habits = await repo.getHabits(userId: 'u1');
        expect(habits, isEmpty);
      });
    });

    group('updateHabit', () {
      test('습관 이름 업데이트', () async {
        final habit = makeHabit();
        await repo.addHabit(habit);
        await repo.updateHabit(habit.copyWith(name: '독서'));
        final habits = await repo.getHabits(userId: 'u1');
        expect(habits.first.name, '독서');
      });
    });

    group('deleteHabit', () {
      test('삭제 후 getHabits에서 제거', () async {
        final habit = makeHabit();
        await repo.addHabit(habit);
        await repo.deleteHabit(habitId: 'h1', userId: 'u1');
        final habits = await repo.getHabits(userId: 'u1');
        expect(habits, isEmpty);
      });

      test('삭제 시 연관 체크인도 제거', () async {
        final habit = makeHabit();
        await repo.addHabit(habit);
        await repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 1));
        await repo.deleteHabit(habitId: 'h1', userId: 'u1');
        final checkins = await repo.getCheckins(habitId: 'h1', userId: 'u1');
        expect(checkins, isEmpty);
      });
    });

    group('checkIn', () {
      test('체크인 후 getCheckins에서 반환', () async {
        await repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 1));
        final checkins = await repo.getCheckins(habitId: 'h1', userId: 'u1');
        expect(checkins.length, 1);
        expect(checkins.first.streakDay, 0);
      });

      test('두 번째 체크인의 streakDay는 1', () async {
        await repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 1));
        await repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 2));
        final checkins = await repo.getCheckins(habitId: 'h1', userId: 'u1');
        final sorted = checkins..sort((a, b) => a.streakDay.compareTo(b.streakDay));
        expect(sorted.last.streakDay, 1);
      });

      test('같은 날 중복 체크인 시 예외 발생', () async {
        await repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 1));
        expect(
          () => repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 1)),
          throwsException,
        );
      });
    });
  });
}
```

**Step 2: VERIFY RED**

```bash
flutter test test/unit/data/firestore_habit_repository_test.dart
```

Expected: 컴파일 에러 (파일 없음)

**Step 3: GREEN — FirestoreHabitRepository 구현**

```dart
// lib/data/repositories/firestore_habit_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class FirestoreHabitRepository implements HabitRepository {
  final FirebaseFirestore _firestore;

  FirestoreHabitRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('habits');

  CollectionReference<Map<String, dynamic>> _checkinsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('checkins');

  String _checkinId(String habitId, String userId, DateTime date) {
    final d = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'checkin_${habitId}_${userId}_$d';
  }

  Habit _habitFromMap(Map<String, dynamic> map) => Habit(
        id: map['id'] as String,
        userId: map['userId'] as String,
        name: map['name'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        isActive: map['isActive'] as bool,
        targetDays: (map['targetDays'] as List).cast<int>(),
        icon: map['icon'] as String? ?? '',
      );

  Map<String, dynamic> _habitToMap(Habit habit) => {
        'id': habit.id,
        'userId': habit.userId,
        'name': habit.name,
        'createdAt': habit.createdAt.toIso8601String(),
        'isActive': habit.isActive,
        'targetDays': habit.targetDays,
        'icon': habit.icon,
      };

  Checkin _checkinFromMap(Map<String, dynamic> map) => Checkin(
        id: map['id'] as String,
        habitId: map['habitId'] as String,
        userId: map['userId'] as String,
        date: DateTime.parse(map['date'] as String),
        streakDay: map['streakDay'] as int,
      );

  Map<String, dynamic> _checkinToMap(Checkin checkin) => {
        'id': checkin.id,
        'habitId': checkin.habitId,
        'userId': checkin.userId,
        'date': checkin.date.toIso8601String(),
        'streakDay': checkin.streakDay,
      };

  @override
  Future<List<Habit>> getHabits({required String userId}) async {
    final snapshot = await _habitsRef(userId).get();
    return snapshot.docs
        .map((doc) => _habitFromMap(doc.data()))
        .where((h) => h.isActive)
        .toList();
  }

  @override
  Future<Habit> addHabit(Habit habit) async {
    await _habitsRef(habit.userId).doc(habit.id).set(_habitToMap(habit));
    return habit;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _habitsRef(habit.userId).doc(habit.id).set(_habitToMap(habit));
  }

  @override
  Future<void> deleteHabit({required String habitId, required String userId}) async {
    await _habitsRef(userId).doc(habitId).delete();
    final checkins = await _checkinsRef(userId)
        .where('habitId', isEqualTo: habitId)
        .get();
    for (final doc in checkins.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final id = _checkinId(habitId, userId, date);
    final existingDoc = await _checkinsRef(userId).doc(id).get();
    if (existingDoc.exists) {
      throw Exception('이미 오늘 체크인했습니다: $id');
    }

    final existingCheckins = await _checkinsRef(userId)
        .where('habitId', isEqualTo: habitId)
        .get();
    final streakDay = existingCheckins.docs.length;

    final checkin = Checkin(
      id: id,
      habitId: habitId,
      userId: userId,
      date: date,
      streakDay: streakDay,
    );
    await _checkinsRef(userId).doc(id).set(_checkinToMap(checkin));
    return checkin;
  }

  @override
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  }) async {
    final snapshot = await _checkinsRef(userId)
        .where('habitId', isEqualTo: habitId)
        .get();
    return snapshot.docs.map((doc) => _checkinFromMap(doc.data())).toList();
  }
}
```

**Step 4: VERIFY GREEN**

```bash
flutter test test/unit/data/firestore_habit_repository_test.dart
```

Expected: 10/10 PASS

**Step 5: Commit**

```bash
git add lib/data/repositories/firestore_habit_repository.dart \
        test/unit/data/firestore_habit_repository_test.dart
git commit -m "feat: implement FirestoreHabitRepository"
```

---

## Task 261: SyncHabitRepository (TDD)

**Files:**

- Create: `lib/data/repositories/sync_habit_repository.dart`
- Create: `test/unit/data/sync_habit_repository_test.dart`

**설계:** 쓰기는 로컬 우선 + 원격 fire-and-forget. 읽기는 로컬. 초기 동기화는 `syncFromRemote()`.

**Step 1: RED — 테스트 작성**

```dart
// test/unit/data/sync_habit_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/data/repositories/sync_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

Habit makeHabit({String id = 'h1', String userId = 'u1'}) => Habit(
      id: id,
      userId: userId,
      name: '운동',
      createdAt: DateTime(2026, 1, 1),
      isActive: true,
    );

Checkin makeCheckin() => Checkin(
      id: 'c1',
      habitId: 'h1',
      userId: 'u1',
      date: DateTime(2026, 3, 1),
      streakDay: 0,
    );

void main() {
  late MockHabitRepository mockLocal;
  late MockHabitRepository mockRemote;
  late SyncHabitRepository repo;

  setUp(() {
    mockLocal = MockHabitRepository();
    mockRemote = MockHabitRepository();
    repo = SyncHabitRepository(local: mockLocal, remote: mockRemote);
  });

  group('SyncHabitRepository', () {
    test('getHabits: 로컬에서 반환', () async {
      when(() => mockLocal.getHabits(userId: 'u1'))
          .thenAnswer((_) async => [makeHabit()]);

      final habits = await repo.getHabits(userId: 'u1');

      expect(habits.length, 1);
      verifyNever(() => mockRemote.getHabits(userId: any(named: 'userId')));
    });

    test('addHabit: 로컬에 즉시 저장 후 원격에 비동기 저장', () async {
      final habit = makeHabit();
      when(() => mockLocal.addHabit(habit)).thenAnswer((_) async => habit);
      when(() => mockRemote.addHabit(habit)).thenAnswer((_) async => habit);

      final result = await repo.addHabit(habit);

      expect(result, habit);
      verify(() => mockLocal.addHabit(habit)).called(1);
      // 원격 저장은 비동기 → 잠시 대기 후 확인
      await Future.delayed(Duration.zero);
      verify(() => mockRemote.addHabit(habit)).called(1);
    });

    test('updateHabit: 로컬 즉시 + 원격 비동기', () async {
      final habit = makeHabit();
      when(() => mockLocal.updateHabit(habit)).thenAnswer((_) async {});
      when(() => mockRemote.updateHabit(habit)).thenAnswer((_) async {});

      await repo.updateHabit(habit);

      verify(() => mockLocal.updateHabit(habit)).called(1);
      await Future.delayed(Duration.zero);
      verify(() => mockRemote.updateHabit(habit)).called(1);
    });

    test('deleteHabit: 로컬 즉시 + 원격 비동기', () async {
      when(() => mockLocal.deleteHabit(habitId: 'h1', userId: 'u1'))
          .thenAnswer((_) async {});
      when(() => mockRemote.deleteHabit(habitId: 'h1', userId: 'u1'))
          .thenAnswer((_) async {});

      await repo.deleteHabit(habitId: 'h1', userId: 'u1');

      verify(() => mockLocal.deleteHabit(habitId: 'h1', userId: 'u1')).called(1);
      await Future.delayed(Duration.zero);
      verify(() => mockRemote.deleteHabit(habitId: 'h1', userId: 'u1')).called(1);
    });

    test('checkIn: 로컬에서 체크인 후 원격 비동기', () async {
      final checkin = makeCheckin();
      when(() => mockLocal.checkIn(habitId: 'h1', userId: 'u1', date: any(named: 'date')))
          .thenAnswer((_) async => checkin);
      when(() => mockRemote.checkIn(habitId: 'h1', userId: 'u1', date: any(named: 'date')))
          .thenAnswer((_) async => checkin);

      final result = await repo.checkIn(habitId: 'h1', userId: 'u1', date: DateTime(2026, 3, 1));

      expect(result, checkin);
      verify(() => mockLocal.checkIn(habitId: 'h1', userId: 'u1', date: any(named: 'date'))).called(1);
    });

    test('getCheckins: 로컬에서 반환', () async {
      when(() => mockLocal.getCheckins(habitId: 'h1', userId: 'u1'))
          .thenAnswer((_) async => [makeCheckin()]);

      final result = await repo.getCheckins(habitId: 'h1', userId: 'u1');

      expect(result.length, 1);
      verifyNever(() => mockRemote.getCheckins(habitId: any(named: 'habitId'), userId: any(named: 'userId')));
    });

    test('syncFromRemote: Firestore 습관을 로컬에 머지', () async {
      final remoteHabits = [makeHabit(id: 'remote-h1')];
      when(() => mockRemote.getHabits(userId: 'u1'))
          .thenAnswer((_) async => remoteHabits);
      when(() => mockLocal.addHabit(any())).thenAnswer((_) async => makeHabit());

      await repo.syncFromRemote(userId: 'u1');

      verify(() => mockLocal.addHabit(any())).called(1);
    });

    test('syncFromRemote: 원격 오류 시 로컬 데이터 유지 (예외 없음)', () async {
      when(() => mockRemote.getHabits(userId: 'u1'))
          .thenThrow(Exception('Network error'));

      // 예외가 전파되지 않아야 함
      await expectLater(repo.syncFromRemote(userId: 'u1'), completes);
    });
  });
}
```

**Step 2: VERIFY RED**

```bash
flutter test test/unit/data/sync_habit_repository_test.dart
```

Expected: 컴파일 에러

**Step 3: GREEN — SyncHabitRepository 구현**

```dart
// lib/data/repositories/sync_habit_repository.dart
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class SyncHabitRepository implements HabitRepository {
  final HabitRepository _local;
  final HabitRepository _remote;

  SyncHabitRepository({
    required HabitRepository local,
    required HabitRepository remote,
  })  : _local = local,
        _remote = remote;

  /// 앱 시작 시 Firestore → Hive 동기화 (best-effort)
  Future<void> syncFromRemote({required String userId}) async {
    try {
      final remoteHabits = await _remote.getHabits(userId: userId);
      for (final habit in remoteHabits) {
        await _local.addHabit(habit);
      }
    } catch (_) {
      // 오프라인이거나 네트워크 오류 → 로컬 데이터 그대로 사용
    }
  }

  @override
  Future<List<Habit>> getHabits({required String userId}) =>
      _local.getHabits(userId: userId);

  @override
  Future<Habit> addHabit(Habit habit) async {
    final result = await _local.addHabit(habit);
    _remote.addHabit(habit).ignore();
    return result;
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _local.updateHabit(habit);
    _remote.updateHabit(habit).ignore();
  }

  @override
  Future<void> deleteHabit({required String habitId, required String userId}) async {
    await _local.deleteHabit(habitId: habitId, userId: userId);
    _remote.deleteHabit(habitId: habitId, userId: userId).ignore();
  }

  @override
  Future<Checkin> checkIn({
    required String habitId,
    required String userId,
    required DateTime date,
  }) async {
    final checkin = await _local.checkIn(
      habitId: habitId,
      userId: userId,
      date: date,
    );
    _remote.checkIn(habitId: habitId, userId: userId, date: date).ignore();
    return checkin;
  }

  @override
  Future<List<Checkin>> getCheckins({
    required String habitId,
    required String userId,
  }) =>
      _local.getCheckins(habitId: habitId, userId: userId);
}
```

**Step 4: VERIFY GREEN**

```bash
flutter test test/unit/data/sync_habit_repository_test.dart
```

Expected: 8/8 PASS

**Step 5: Commit**

```bash
git add lib/data/repositories/sync_habit_repository.dart \
        test/unit/data/sync_habit_repository_test.dart
git commit -m "feat: implement SyncHabitRepository (offline-first + Firestore sync)"
```

---

## Task 262: lastSyncedAtProvider + 동기화 상태 표시 (TDD)

**Files:**

- Create: `lib/presentation/providers/sync_provider.dart`
- Create: `test/unit/presentation/sync_provider_test.dart`
- Modify: `lib/presentation/screens/habit_list_screen.dart`

**Step 1: RED — 테스트 작성**

```dart
// test/unit/presentation/sync_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/providers/sync_provider.dart';

void main() {
  group('lastSyncedAtProvider', () {
    test('초기값은 null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(lastSyncedAtProvider), isNull);
    });

    test('값 업데이트 가능', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final now = DateTime(2026, 3, 10, 12, 0);
      container.read(lastSyncedAtProvider.notifier).state = now;
      expect(container.read(lastSyncedAtProvider), equals(now));
    });
  });
}
```

**Step 2: VERIFY RED**

```bash
flutter test test/unit/presentation/sync_provider_test.dart
```

Expected: 컴파일 에러

**Step 3: GREEN — Provider 구현**

```dart
// lib/presentation/providers/sync_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lastSyncedAtProvider = StateProvider<DateTime?>((ref) => null);
```

**Step 4: VERIFY GREEN**

```bash
flutter test test/unit/presentation/sync_provider_test.dart
```

Expected: 2/2 PASS

**Step 5: habit_list_screen.dart에 싱크 시간 표시**

`_HabitListHeader` 또는 앱바 타이틀 아래 작은 텍스트 추가:

```dart
// import 추가
import 'package:habit_rabbit/presentation/providers/sync_provider.dart';

// 앱바 또는 상단에 lastSyncedAt 표시
Consumer(builder: (context, ref, _) {
  final syncedAt = ref.watch(lastSyncedAtProvider);
  if (syncedAt == null) return const SizedBox.shrink();
  return Text(
    '동기화: ${syncedAt.hour}:${syncedAt.minute.toString().padLeft(2, '0')}',
    style: const TextStyle(fontSize: 11, color: Colors.grey),
  );
}),
```

**Step 6: Commit**

```bash
git add lib/presentation/providers/sync_provider.dart \
        test/unit/presentation/sync_provider_test.dart \
        lib/presentation/screens/habit_list_screen.dart
git commit -m "feat: add lastSyncedAtProvider and sync time display"
```

---

## Task 263: main.dart 연결 + 초기 동기화

**Files:**

- Modify: `lib/main.dart`

**Step 1: main.dart 수정**

```dart
import 'package:habit_rabbit/data/repositories/firestore_habit_repository.dart';
import 'package:habit_rabbit/data/repositories/sync_habit_repository.dart';

// HiveHabitRepository 대신 SyncHabitRepository 사용
void main() async {
  // ... 기존 초기화 코드 ...

  final syncHabitRepo = SyncHabitRepository(
    local: HiveHabitRepository(habitBox),
    remote: FirestoreHabitRepository(),
  );

  runApp(ProviderScope(
    overrides: [
      habitRepositoryProvider.overrideWithValue(syncHabitRepo),
      // ... 기타 overrides ...
    ],
    child: HabitRabbitApp(
      notifRepo: notifRepo,
      onboardingRepo: onboardingRepo,
      syncHabitRepo: syncHabitRepo,  // 초기 동기화를 위해 전달
    ),
  ));
}
```

`HabitRabbitApp`에서 auth 상태 변경 시 동기화 실행:

```dart
// HabitRabbitApp.build()에서
ref.listen(currentUserProvider, (_, next) {
  if (next != null) {
    // 로그인 후 Firestore → Hive 동기화
    syncHabitRepo.syncFromRemote(userId: next.id).then((_) {
      ref.read(lastSyncedAtProvider.notifier).state = DateTime.now();
    }).ignore();
  }
});
```

**Step 2: 전체 테스트 확인**

```bash
flutter test
```

Expected: 모든 테스트 PASS

**Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "feat: wire SyncHabitRepository in main.dart with auto-sync on login"
```

---

## Task 264: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git add docs/plans/2026-03-10-mvp-firestore-sync.md
git commit -m "chore: mvp firestore sync complete"
```

---

## Firestore 보안 규칙 (사용자 직접 설정)

Firebase 콘솔 → Firestore → Rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
