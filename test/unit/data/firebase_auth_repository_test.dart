import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/data/repositories/firebase_auth_repository.dart';

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockUserCredential extends Mock implements fb.UserCredential {}

class MockFirebaseUser extends Mock implements fb.User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class FakeAuthCredential extends Fake implements fb.AuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FirebaseAuthRepository repo;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    repo = FirebaseAuthRepository(auth: mockAuth, googleSignIn: mockGoogleSignIn);
  });

  group('FirebaseAuthRepository', () {
    test('Google 로그인 시 Firebase UID가 반환됨', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();
      final mockCredential = MockUserCredential();
      final mockUser = MockFirebaseUser();

      when(() => mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication)
          .thenAnswer((_) async => mockGoogleAuth);
      when(() => mockGoogleAuth.accessToken).thenReturn('access-token');
      when(() => mockGoogleAuth.idToken).thenReturn('id-token');
      when(() => mockAuth.signInWithCredential(any()))
          .thenAnswer((_) async => mockCredential);
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('google-firebase-uid');
      when(() => mockUser.email).thenReturn('test@gmail.com');

      final user = await repo.signInWithGoogle();

      expect(user.id, 'google-firebase-uid');
      expect(user.email, 'test@gmail.com');
    });

    test('Google 로그인 취소 시 예외 발생', () async {
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      expect(() => repo.signInWithGoogle(), throwsException);
    });

    test('게스트 로그인 시 익명 UID가 반환됨', () async {
      final mockCredential = MockUserCredential();
      final mockUser = MockFirebaseUser();

      when(() => mockAuth.signInAnonymously())
          .thenAnswer((_) async => mockCredential);
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('anon-uid');
      when(() => mockUser.email).thenReturn(null);

      final user = await repo.signInAsGuest();

      expect(user.id, 'anon-uid');
      expect(user.email, '');
      expect(user.isPremium, false);
    });

    test('로그아웃 시 Firebase와 Google signOut 모두 호출됨', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      await repo.signOut();

      verify(() => mockGoogleSignIn.signOut()).called(1);
      verify(() => mockAuth.signOut()).called(1);
    });

    test('currentUser는 authStateChanges를 도메인 User로 변환함', () async {
      final mockUser = MockFirebaseUser();
      when(() => mockUser.uid).thenReturn('stream-uid');
      when(() => mockUser.email).thenReturn('stream@test.com');
      when(() => mockAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      final user = await repo.currentUser.first;

      expect(user, isNotNull);
      expect(user!.id, 'stream-uid');
      expect(user.email, 'stream@test.com');
    });

    test('currentUser는 로그아웃 상태에서 null 반환', () async {
      when(() => mockAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      final user = await repo.currentUser.first;

      expect(user, isNull);
    });
  });
}
