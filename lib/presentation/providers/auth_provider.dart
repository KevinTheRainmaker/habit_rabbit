import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/repositories/in_memory_auth_repository.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return InMemoryAuthRepository();
});

final currentUserProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.currentUser;
});
