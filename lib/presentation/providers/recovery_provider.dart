import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/repositories/in_memory_recovery_repository.dart';
import 'package:habit_rabbit/domain/entities/recovery_ticket.dart';
import 'package:habit_rabbit/domain/repositories/recovery_repository.dart';

final recoveryRepositoryProvider = Provider<RecoveryRepository>(
  (ref) => InMemoryRecoveryRepository(),
);

final recoveryTicketProvider =
    FutureProvider.family<RecoveryTicket, String>((ref, userId) async {
  return ref.watch(recoveryRepositoryProvider).getTicket(userId: userId);
});
