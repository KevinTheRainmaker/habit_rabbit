import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<User> withGoogle() => _repository.signInWithGoogle();
  Future<User> withApple() => _repository.signInWithApple();
}
