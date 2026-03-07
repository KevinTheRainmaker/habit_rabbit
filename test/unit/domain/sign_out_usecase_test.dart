import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';
import 'package:habit_rabbit/domain/usecases/sign_out_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOutUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignOutUseCase(repository);
  });

  group('SignOutUseCase', () {
    test('signOut 호출 시 repository.signOut 실행', () async {
      when(() => repository.signOut()).thenAnswer((_) async {});

      await useCase();

      verify(() => repository.signOut()).called(1);
    });
  });
}
