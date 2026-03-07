import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('currentUserProvider', () {
    test('로그인된 사용자를 스트림으로 반환', () async {
      final mock = MockAuthRepository();
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      when(() => mock.currentUser).thenAnswer((_) => Stream.value(user));

      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mock)],
      );
      addTearDown(container.dispose);

      final result = await container.read(currentUserProvider.future);

      expect(result?.id, equals('uid-1'));
    });

    test('로그아웃 상태이면 null 반환', () async {
      final mock = MockAuthRepository();
      when(() => mock.currentUser).thenAnswer((_) => Stream.value(null));

      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mock)],
      );
      addTearDown(container.dispose);

      final result = await container.read(currentUserProvider.future);

      expect(result, isNull);
    });
  });
}
