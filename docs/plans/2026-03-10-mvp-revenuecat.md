# Habit Rabbit MVP RevenueCat 연동 — Implementation Plan

**Goal:** `HiveSubscriptionRepository`의 더미 구현을 실제 RevenueCat SDK로 교체

**외부 설정 (코드 구현 전 사용자가 직접 해야 할 작업):**

1. RevenueCat 콘솔(app.revenuecat.com)에서 프로젝트 생성
2. iOS/Android 앱 등록 → API Key 확보
3. Entitlement ID "premium" 생성
4. Product (구독 상품) 등록 → Offering에 "default" 패키지 구성
5. App Store Connect / Google Play에 인앱 결제 상품 등록

---

## Task 250: pubspec.yaml purchases_flutter 주석 해제

**Files:**

- Modify: `pubspec.yaml`

**Action:** `purchases_flutter` 주석 해제 후 `flutter pub get`

**Commit:**

```bash
git commit -m "chore: enable purchases_flutter in pubspec"
```

---

## Task 251: RevenueCatSubscriptionRepository 구현 (TDD)

**Files:**

- Create: `lib/data/datasources/revenuecat_client.dart`
- Create: `lib/data/repositories/revenuecat_subscription_repository.dart`
- Create: `test/unit/data/revenuecat_subscription_repository_test.dart`

**설계:** `Purchases` 정적 API를 직접 호출하면 테스트 불가.
→ `RevenueCatClient` 추상 인터페이스로 감싸고 DI로 주입.

**RED:** 테스트 추가:

```dart
test('isPremium: premium entitlement 활성화 시 true 반환', () async { ... });
test('isPremium: entitlement 없으면 false 반환', () async { ... });
test('purchasePremium: 성공 시 true 반환', () async { ... });
test('purchasePremium: 실패 시 false 반환', () async { ... });
test('restorePurchases: premium 복원 시 true 반환', () async { ... });
```

**GREEN:** RevenueCatClient 추상 인터페이스 + RevenueCatSubscriptionRepository:

```dart
// lib/data/datasources/revenuecat_client.dart
abstract class RevenueCatClient {
  Future<bool> isPremiumActive();
  Future<bool> purchasePremiumPackage();
  Future<bool> restorePurchases();
}
```

```dart
// lib/data/repositories/revenuecat_subscription_repository.dart
class RevenueCatSubscriptionRepository implements SubscriptionRepository {
  final RevenueCatClient _client;

  RevenueCatSubscriptionRepository({RevenueCatClient? client})
      : _client = client ?? PurchasesWrapper();

  @override
  Future<bool> isPremium() => _client.isPremiumActive();

  @override
  Future<bool> purchasePremium() => _client.purchasePremiumPackage();

  @override
  Future<bool> restorePurchases() => _client.restorePurchases();
}
```

**Commit:**

```bash
git commit -m "feat: implement RevenueCatSubscriptionRepository with DI"
```

---

## Task 252: PurchasesWrapper 구현 + main.dart 연결

**Files:**

- Create: `lib/data/datasources/purchases_wrapper.dart`
- Modify: `lib/main.dart`

**Action:**

```dart
// lib/data/datasources/purchases_wrapper.dart
import 'package:purchases_flutter/purchases_flutter.dart';
import 'revenuecat_client.dart';

class PurchasesWrapper implements RevenueCatClient {
  static const _entitlementId = 'premium';

  @override
  Future<bool> isPremiumActive() async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(_entitlementId);
  }

  @override
  Future<bool> purchasePremiumPackage() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.monthly;
      if (package == null) return false;
      final info = await Purchases.purchasePackage(package);
      return info.entitlements.active.containsKey(_entitlementId);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    return info.entitlements.active.containsKey(_entitlementId);
  }
}
```

**main.dart 변경:**

```dart
// Purchases.configure는 Firebase 초기화 후에 호출
await Purchases.configure(PurchasesConfiguration('YOUR_API_KEY'));

// ProviderScope overrides
subscriptionRepositoryProvider.overrideWithValue(RevenueCatSubscriptionRepository()),
```

**Commit:**

```bash
git commit -m "feat: wire RevenueCatSubscriptionRepository in main.dart"
```

---

## Task 253: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp revenuecat integration complete"
```
