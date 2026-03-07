import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/usecases/sign_in_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignInUseCase(repository);
  });

  group('SignInUseCase', () {
    test('Google 로그인 성공 시 User 반환', () async {
      const expected = User(id: 'uid-1', email: 'g@test.com', isPremium: false);
      when(() => repository.signInWithGoogle()).thenAnswer((_) async => expected);

      final result = await useCase.withGoogle();

      expect(result.id, equals('uid-1'));
      verify(() => repository.signInWithGoogle()).called(1);
    });

    test('Apple 로그인 성공 시 User 반환', () async {
      const expected = User(id: 'uid-2', email: 'a@test.com', isPremium: false);
      when(() => repository.signInWithApple()).thenAnswer((_) async => expected);

      final result = await useCase.withApple();

      expect(result.id, equals('uid-2'));
      verify(() => repository.signInWithApple()).called(1);
    });

    test('로그인 실패 시 예외 전파', () async {
      when(() => repository.signInWithGoogle()).thenThrow(Exception('네트워크 오류'));

      expect(() => useCase.withGoogle(), throwsException);
    });
  });
}
