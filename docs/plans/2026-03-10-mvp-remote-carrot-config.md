# Story 27: 당근 포인트 원격 설정 — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Firebase Remote Config를 통해 당근 포인트 지급량을 앱 업데이트 없이 원격으로 조정

**Architecture:**
`CarrotPointConfig` 순수 도메인 모델 → `RemoteConfigClient` 추상 인터페이스 →
`FirebaseRemoteConfigClient` (실제) / `DefaultRemoteConfigClient` (테스트/폴백) →
`carrotConfigProvider` (Riverpod) → `habit_list_screen.dart` 체크인 시 적용.

기존 `Checkin.carrotPoints` getter는 backward compat 유지. 체크인 시 `config.computePoints(streakDay)` 사용으로 전환.

**Tech Stack:** Flutter, Riverpod, firebase_remote_config ^5.x, mocktail (테스트)

---

## Task 254: CarrotPointConfig 도메인 모델 (TDD)

**Files:**

- Create: `lib/domain/models/carrot_point_config.dart`
- Create: `test/unit/domain/carrot_point_config_test.dart`

**Step 1: RED — 테스트 작성**

```dart
// test/unit/domain/carrot_point_config_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

void main() {
  group('CarrotPointConfig', () {
    test('기본값: 기본 10 포인트, 7일 +5, 30일 +10, 100일 +15', () {
      const config = CarrotPointConfig();
      expect(config.basePoints, 10);
      expect(config.sevenDayBonus, 5);
      expect(config.thirtyDayBonus, 10);
      expect(config.hundredDayBonus, 15);
    });

    test('streakDay 0: 기본 포인트만 반환', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(0), 10);
    });

    test('streakDay 6 (7일차): 기본 + 7일 보너스', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(6), 15);
    });

    test('streakDay 29 (30일차): 기본 + 30일 보너스', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(29), 20);
    });

    test('streakDay 99 (100일차): 기본 + 100일 보너스', () {
      const config = CarrotPointConfig();
      expect(config.computePoints(99), 25);
    });

    test('커스텀 설정으로 포인트 계산', () {
      const config = CarrotPointConfig(basePoints: 20, sevenDayBonus: 10);
      expect(config.computePoints(0), 20);
      expect(config.computePoints(6), 30);
    });

    test('defaults 상수는 기본 CarrotPointConfig와 동일', () {
      expect(CarrotPointConfig.defaults, const CarrotPointConfig());
    });
  });
}
```

**Step 2: VERIFY RED**

```bash
flutter test test/unit/domain/carrot_point_config_test.dart
```

Expected: 컴파일 에러 (파일 없음)

**Step 3: GREEN — 구현**

```dart
// lib/domain/models/carrot_point_config.dart
import 'package:equatable/equatable.dart';

class CarrotPointConfig extends Equatable {
  final int basePoints;
  final int sevenDayBonus;
  final int thirtyDayBonus;
  final int hundredDayBonus;

  static const defaults = CarrotPointConfig();

  const CarrotPointConfig({
    this.basePoints = 10,
    this.sevenDayBonus = 5,
    this.thirtyDayBonus = 10,
    this.hundredDayBonus = 15,
  });

  int computePoints(int streakDay) {
    int points = basePoints;
    if (streakDay == 99) {
      points += hundredDayBonus;
    } else if (streakDay == 29) {
      points += thirtyDayBonus;
    } else if (streakDay == 6) {
      points += sevenDayBonus;
    }
    return points;
  }

  @override
  List<Object> get props => [basePoints, sevenDayBonus, thirtyDayBonus, hundredDayBonus];
}
```

**Step 4: VERIFY GREEN**

```bash
flutter test test/unit/domain/carrot_point_config_test.dart
```

Expected: 7/7 PASS

**Step 5: 전체 테스트 확인**

```bash
flutter test
```

Expected: 기존 테스트 모두 통과 (419 + 7 = 426개)

**Step 6: Commit**

```bash
git add lib/domain/models/carrot_point_config.dart test/unit/domain/carrot_point_config_test.dart
git commit -m "feat: add CarrotPointConfig domain model"
```

---

## Task 255: RemoteConfigClient 추상 + 구현체 (TDD)

**Files:**

- Create: `lib/data/datasources/remote_config_client.dart`
- Create: `lib/data/datasources/default_remote_config_client.dart`
- Create: `lib/data/datasources/firebase_remote_config_client.dart`
- Create: `test/unit/data/remote_config_client_test.dart`

**Step 1: RED — 테스트 작성**

```dart
// test/unit/data/remote_config_client_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/datasources/default_remote_config_client.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

void main() {
  group('DefaultRemoteConfigClient', () {
    test('fetchCarrotConfig는 CarrotPointConfig.defaults 반환', () async {
      final client = DefaultRemoteConfigClient();
      final config = await client.fetchCarrotConfig();
      expect(config, CarrotPointConfig.defaults);
    });

    test('반환값은 기본 포인트 설정', () async {
      final client = DefaultRemoteConfigClient();
      final config = await client.fetchCarrotConfig();
      expect(config.basePoints, 10);
      expect(config.sevenDayBonus, 5);
    });
  });
}
```

**Step 2: VERIFY RED**

```bash
flutter test test/unit/data/remote_config_client_test.dart
```

Expected: 컴파일 에러

**Step 3: GREEN — 추상 인터페이스**

```dart
// lib/data/datasources/remote_config_client.dart
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

abstract class RemoteConfigClient {
  Future<CarrotPointConfig> fetchCarrotConfig();
}
```

**Step 4: GREEN — DefaultRemoteConfigClient (테스트/오프라인 폴백)**

```dart
// lib/data/datasources/default_remote_config_client.dart
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';
import 'remote_config_client.dart';

class DefaultRemoteConfigClient implements RemoteConfigClient {
  @override
  Future<CarrotPointConfig> fetchCarrotConfig() async {
    return CarrotPointConfig.defaults;
  }
}
```

**Step 5: GREEN — FirebaseRemoteConfigClient**

```dart
// lib/data/datasources/firebase_remote_config_client.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';
import 'remote_config_client.dart';

class FirebaseRemoteConfigClient implements RemoteConfigClient {
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigClient({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  @override
  Future<CarrotPointConfig> fetchCarrotConfig() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // 네트워크 오류 시 캐시된 값 또는 기본값 사용
    }
    return CarrotPointConfig(
      basePoints: _remoteConfig.getInt('carrot_base_points'),
      sevenDayBonus: _remoteConfig.getInt('carrot_7day_bonus'),
      thirtyDayBonus: _remoteConfig.getInt('carrot_30day_bonus'),
      hundredDayBonus: _remoteConfig.getInt('carrot_100day_bonus'),
    );
  }
}
```

**Step 6: VERIFY GREEN**

```bash
flutter test test/unit/data/remote_config_client_test.dart
```

Expected: 2/2 PASS

**Step 7: Commit**

```bash
git add lib/data/datasources/remote_config_client.dart \
        lib/data/datasources/default_remote_config_client.dart \
        lib/data/datasources/firebase_remote_config_client.dart \
        test/unit/data/remote_config_client_test.dart
git commit -m "feat: add RemoteConfigClient with Firebase and default implementations"
```

---

## Task 256: firebase_remote_config 패키지 + carrotConfigProvider (TDD)

**Files:**

- Modify: `pubspec.yaml`
- Create: `lib/presentation/providers/carrot_config_provider.dart`
- Create: `test/unit/presentation/carrot_config_provider_test.dart`
- Modify: `lib/main.dart`

**Step 1: pubspec.yaml 수정**

```yaml
# lib/data/datasources/firebase_remote_config_client.dart 컴파일을 위해 추가
firebase_remote_config: ^5.4.4
```

`firebase_remote_config`를 `pubspec.yaml`의 Firebase 섹션 아래에 추가:

```yaml
# Firebase / 인증
firebase_core: ^3.3.0
firebase_auth: ^5.1.4
firebase_remote_config: ^5.4.4 # 추가
google_sign_in: ^6.2.1
```

```bash
flutter pub get
```

**Step 2: RED — 테스트 작성**

```dart
// test/unit/presentation/carrot_config_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/data/datasources/remote_config_client.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';
import 'package:habit_rabbit/presentation/providers/carrot_config_provider.dart';

class MockRemoteConfigClient extends Mock implements RemoteConfigClient {}

void main() {
  late MockRemoteConfigClient mockClient;

  setUp(() {
    mockClient = MockRemoteConfigClient();
  });

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: [
      remoteConfigClientProvider.overrideWithValue(mockClient),
    ],
  );

  group('carrotConfigProvider', () {
    test('RemoteConfigClient로부터 CarrotPointConfig 로드', () async {
      when(() => mockClient.fetchCarrotConfig())
          .thenAnswer((_) async => const CarrotPointConfig(basePoints: 15));

      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(carrotConfigProvider.future);
      expect(config.basePoints, 15);
    });

    test('기본 클라이언트는 CarrotPointConfig.defaults 반환', () async {
      when(() => mockClient.fetchCarrotConfig())
          .thenAnswer((_) async => CarrotPointConfig.defaults);

      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(carrotConfigProvider.future);
      expect(config, CarrotPointConfig.defaults);
    });
  });
}
```

**Step 3: VERIFY RED**

```bash
flutter test test/unit/presentation/carrot_config_provider_test.dart
```

Expected: 컴파일 에러 (provider 없음)

**Step 4: GREEN — Provider 구현**

```dart
// lib/presentation/providers/carrot_config_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/datasources/default_remote_config_client.dart';
import 'package:habit_rabbit/data/datasources/firebase_remote_config_client.dart';
import 'package:habit_rabbit/data/datasources/remote_config_client.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

final remoteConfigClientProvider = Provider<RemoteConfigClient>((ref) {
  return FirebaseRemoteConfigClient();
});

final carrotConfigProvider = FutureProvider<CarrotPointConfig>((ref) async {
  final client = ref.watch(remoteConfigClientProvider);
  return client.fetchCarrotConfig();
});
```

**Step 5: VERIFY GREEN**

```bash
flutter test test/unit/presentation/carrot_config_provider_test.dart
```

Expected: 2/2 PASS

**Step 6: main.dart — Remote Config 기본값 설정**

`lib/main.dart`에 Remote Config 기본값 등록 추가:

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

// Firebase.initializeApp() 이후에 추가
await FirebaseRemoteConfig.instance.setDefaults({
  'carrot_base_points': 10,
  'carrot_7day_bonus': 5,
  'carrot_30day_bonus': 10,
  'carrot_100day_bonus': 15,
});
```

**Step 7: 전체 테스트 확인**

```bash
flutter test
```

Expected: 모두 PASS

**Step 8: Commit**

```bash
git add pubspec.yaml pubspec.lock \
        lib/presentation/providers/carrot_config_provider.dart \
        test/unit/presentation/carrot_config_provider_test.dart \
        lib/main.dart
git commit -m "feat: add carrotConfigProvider with Firebase Remote Config"
```

---

## Task 257: habit_list_screen.dart 체크인 포인트 적용 (TDD)

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**Goal:** 체크인 시 `checkin.carrotPoints` (hardcoded) 대신 `carrotConfigProvider`의 config를 사용

**Step 1: 현재 코드 확인**

`habit_list_screen.dart`에서 체크인 후 포인트를 추가하는 부분 찾기:

```dart
// 현재 코드 (~line 490)
ref.read(carrotPointsProvider.notifier).add(checkin.carrotPoints);
// ...
_earnedPoints = checkin.carrotPoints;
```

**Step 2: RED — 테스트 추가**

`test/widget/habit_list_screen_test.dart`에 Remote Config 기반 포인트 테스트 추가:

```dart
testWidgets('체크인 시 carrotConfigProvider의 포인트 사용', (tester) async {
  // basePoints를 20으로 설정한 커스텀 config
  final customConfig = const CarrotPointConfig(basePoints: 20);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // ... 기존 overrides ...
        carrotConfigProvider.overrideWith((_) async => customConfig),
      ],
      child: const MaterialApp(home: HabitListScreen()),
    ),
  );

  // 체크인 후 20 포인트 획득 확인
  // ... 탭 + verify carrotPoints == 20
});
```

**Note:** 위 테스트는 기존 테스트 패턴을 따라 작성. 기존 테스트들은 `carrotConfigProvider` override 없이도 `CarrotPointConfig.defaults` (10 포인트)를 반환하므로 깨지지 않음.

**Step 3: GREEN — habit_list_screen.dart 수정**

```dart
// 1. import 추가
import 'package:habit_rabbit/presentation/providers/carrot_config_provider.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

// 2. _onTap 또는 체크인 처리 부분에서:
// 변경 전:
ref.read(carrotPointsProvider.notifier).add(checkin.carrotPoints);
_earnedPoints = checkin.carrotPoints;

// 변경 후:
final config = ref.read(carrotConfigProvider).valueOrNull ?? CarrotPointConfig.defaults;
final points = config.computePoints(checkin.streakDay);
ref.read(carrotPointsProvider.notifier).add(points);
_earnedPoints = points;
```

**Step 4: VERIFY GREEN**

```bash
flutter test test/widget/habit_list_screen_test.dart
```

Expected: 모든 테스트 PASS (기존 테스트는 defaults와 동일한 값 사용)

**Step 5: 전체 테스트**

```bash
flutter test
```

Expected: 모두 PASS

**Step 6: Commit**

```bash
git add lib/presentation/screens/habit_list_screen.dart \
        test/widget/habit_list_screen_test.dart
git commit -m "feat: use carrotConfigProvider for checkin point calculation"
```

---

## Task 258: 전체 테스트 통과 확인 + 플랜 커밋

**Step 1: 전체 검증**

```bash
flutter test
flutter analyze --no-fatal-infos
```

Expected: 모든 테스트 PASS, analyze 에러 0건

**Step 2: Commit**

```bash
git add docs/plans/2026-03-10-mvp-remote-carrot-config.md
git commit -m "chore: mvp remote carrot config complete"
```

---

## Firebase Remote Config 콘솔 설정 (사용자 직접)

Firebase 콘솔에서 다음 파라미터 생성:

| 파라미터 키           | 기본값 | 설명               |
| --------------------- | ------ | ------------------ |
| `carrot_base_points`  | 10     | 기본 체크인 포인트 |
| `carrot_7day_bonus`   | 5      | 7일 연속 보너스    |
| `carrot_30day_bonus`  | 10     | 30일 연속 보너스   |
| `carrot_100day_bonus` | 15     | 100일 연속 보너스  |
