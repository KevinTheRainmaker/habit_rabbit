import 'package:habit_rabbit/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<User?> get currentUser;
  Future<User> signInWithApple();
  Future<User> signInWithGoogle();
  Future<User> signInAsGuest();
  Future<void> signOut();
}
