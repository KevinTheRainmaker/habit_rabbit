import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('AuthRepository', () {
    test('signInWithApple 성공 시 User 반환', () async {
      const expected = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => repository.signInWithApple())
          .thenAnswer((_) async => expected);

      final result = await repository.signInWithApple();

      expect(result, equals(expected));
    });

    test('signInWithGoogle 성공 시 User 반환', () async {
      const expected = User(id: 'uid-2', email: 'g@test.com', isPremium: false);
      when(() => repository.signInWithGoogle())
          .thenAnswer((_) async => expected);

      final result = await repository.signInWithGoogle();

      expect(result, equals(expected));
    });

    test('signOut 호출 가능', () async {
      when(() => repository.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => repository.signOut()).called(1);
    });

    test('currentUser 스트림 제공', () {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => repository.currentUser)
          .thenAnswer((_) => Stream.value(user));

      expect(repository.currentUser, emits(user));
    });
  });
}
