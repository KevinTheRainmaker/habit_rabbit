import 'dart:async';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';

class HiveAuthRepository implements AuthRepository {
  final Box _box;
  final _controller = StreamController<User?>.broadcast();

  static const _userKey = 'current_user';

  HiveAuthRepository(this._box);

  User? _decodeUser(dynamic raw) {
    if (raw == null) return null;
    final map = raw as Map;
    return User(
      id: map['id'] as String,
      email: map['email'] as String? ?? '',
      isPremium: map['isPremium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> _encodeUser(User user) => {
        'id': user.id,
        'email': user.email,
        'isPremium': user.isPremium,
      };

  @override
  Stream<User?> get currentUser async* {
    yield _decodeUser(_box.get(_userKey));
    yield* _controller.stream;
  }

  @override
  Future<User> signInAsGuest() async {
    const user = User(id: 'guest-uid', email: '', isPremium: false);
    await _box.put(_userKey, _encodeUser(user));
    _controller.add(user);
    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    const user = User(id: 'google-uid', email: '', isPremium: false);
    await _box.put(_userKey, _encodeUser(user));
    _controller.add(user);
    return user;
  }

  @override
  Future<User> signInWithApple() async {
    const user = User(id: 'apple-uid', email: '', isPremium: false);
    await _box.put(_userKey, _encodeUser(user));
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await _box.delete(_userKey);
    _controller.add(null);
  }
}
