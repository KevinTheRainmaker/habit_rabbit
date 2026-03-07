import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_auth_repository.dart';
import 'package:habit_rabbit/domain/entities/user.dart';

void main() {
  late InMemoryAuthRepository repository;

  setUp(() {
    repository = InMemoryAuthRepository();
  });

  group('InMemoryAuthRepository', () {
    test('초기 상태: currentUser는 null', () async {
      final user = await repository.currentUser.first;
      expect(user, isNull);
    });

    test('signInWithGoogle: User 반환 후 currentUser에 반영', () async {
      final user = await repository.signInWithGoogle();

      expect(user.id, isNotEmpty);
      expect(user.email, contains('@'));
      expect(user.isPremium, isFalse);

      final current = await repository.currentUser.first;
      expect(current?.id, equals(user.id));
    });

    test('signInWithApple: User 반환 후 currentUser에 반영', () async {
      final user = await repository.signInWithApple();

      expect(user.id, isNotEmpty);

      final current = await repository.currentUser.first;
      expect(current?.id, equals(user.id));
    });

    test('signOut: currentUser가 null로 초기화', () async {
      await repository.signInWithGoogle();
      await repository.signOut();

      final current = await repository.currentUser.first;
      expect(current, isNull);
    });

    test('signOut 후 재로그인 가능', () async {
      await repository.signInWithGoogle();
      await repository.signOut();
      final user = await repository.signInWithApple();

      expect(user, isA<User>());
    });
  });
}
