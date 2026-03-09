# Habit Rabbit MVP Firebase Auth 연동 — Implementation Plan

**Goal:** `HiveAuthRepository`의 하드코딩된 더미 UID를 실제 Firebase Auth로 교체

**외부 설정 (코드 구현 전 사용자가 직접 해야 할 작업):**

1. Firebase 콘솔(console.firebase.google.com)에서 프로젝트 생성
2. Android 앱 등록 → `google-services.json` → `android/app/` 에 위치
3. iOS 앱 등록 → `GoogleService-Info.plist` → `ios/Runner/` 에 위치
4. Firebase 콘솔에서 Google Sign-In, Anonymous 인증 활성화
5. Apple Sign-In: Apple Developer 계정에서 Sign-In with Apple 설정

---

## Task 246: pubspec.yaml Firebase 패키지 주석 해제

**Files:**

- Modify: `pubspec.yaml`

**Action:** firebase_core, firebase_auth, google_sign_in, sign_in_with_apple 주석 해제 후 `flutter pub get`

**Commit:**

```bash
git commit -m "chore: enable Firebase and sign-in packages in pubspec"
```

---

## Task 247: FirebaseAuthRepository 구현 (TDD)

**Files:**

- Create: `lib/data/repositories/firebase_auth_repository.dart`
- Create: `test/unit/data/firebase_auth_repository_test.dart`

**RED**: 테스트 추가:

```dart
test('Google 로그인 시 Firebase UID가 반환됨', () async { ... });
test('Apple 로그인 시 Firebase UID가 반환됨', () async { ... });
test('게스트 로그인 시 익명 UID가 반환됨', () async { ... });
test('로그아웃 시 currentUser가 null', () async { ... });
```

**GREEN**: DI 방식으로 `FirebaseAuth`, `GoogleSignIn` 주입받아 구현:

```dart
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<User?> get currentUser => _auth.authStateChanges().map((fbUser) {
    if (fbUser == null) return null;
    return User(id: fbUser.uid, email: fbUser.email ?? '', isPremium: false);
  });

  @override
  Future<User> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google 로그인 취소');
    final auth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return User(id: result.user!.uid, email: result.user!.email ?? '', isPremium: false);
  }

  @override
  Future<User> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email],
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    final result = await _auth.signInWithCredential(credential);
    return User(id: result.user!.uid, email: result.user!.email ?? '', isPremium: false);
  }

  @override
  Future<User> signInAsGuest() async {
    final result = await _auth.signInAnonymously();
    return User(id: result.user!.uid, email: '', isPremium: false);
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
```

**Step 5: 커밋**

```bash
git commit -m "feat: implement FirebaseAuthRepository with DI"
```

---

## Task 248: main.dart Firebase 초기화 연결

**Files:**

- Modify: `lib/main.dart`

**Action:**

1. `Firebase.initializeApp()` 추가
2. `authRepositoryProvider`를 `FirebaseAuthRepository`로 교체
3. `HiveAuthRepository`는 더 이상 사용 안 함

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 추가
  await Hive.initFlutter();
  // ...
  authRepositoryProvider.overrideWithValue(FirebaseAuthRepository()),
```

**Step 5: 커밋**

```bash
git commit -m "feat: wire FirebaseAuthRepository in main.dart"
```

---

## Task 249: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp firebase auth integration complete"
```
