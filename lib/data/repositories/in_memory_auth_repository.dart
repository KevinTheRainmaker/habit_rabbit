import 'dart:async';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  final _controller = StreamController<User?>.broadcast();
  User? _currentUser;

  @override
  Stream<User?> get currentUser async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<User> signInWithGoogle() async {
    const user = User(
      id: 'dev-google-uid',
      email: 'dev@google.com',
      isPremium: false,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<User> signInWithApple() async {
    const user = User(
      id: 'dev-apple-uid',
      email: 'dev@apple.com',
      isPremium: false,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<User> signInAsGuest() async {
    const user = User(
      id: 'guest-uid',
      email: 'guest@habit-rabbit.app',
      isPremium: false,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}
