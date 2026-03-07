import 'package:habit_rabbit/domain/entities/recovery_ticket.dart';
import 'package:habit_rabbit/domain/repositories/recovery_repository.dart';

class InMemoryRecoveryRepository implements RecoveryRepository {
  final Map<String, RecoveryTicket> _tickets = {};

  RecoveryTicket _getOrCreate(String userId) {
    return _tickets[userId] ??
        const RecoveryTicket(count: 0, freeTrialUsed: false);
  }

  @override
  Future<RecoveryTicket> getTicket({required String userId}) async {
    return _getOrCreate(userId);
  }

  @override
  Future<void> useTicket({required String userId}) async {
    final ticket = _getOrCreate(userId);
    if (ticket.count <= 0) throw Exception('티켓이 없습니다');
    _tickets[userId] = ticket.copyWith(count: ticket.count - 1);
  }

  @override
  Future<void> useFreeTrial({required String userId}) async {
    final ticket = _getOrCreate(userId);
    _tickets[userId] = ticket.copyWith(freeTrialUsed: true);
  }

  void addTicket({required String userId, required int count}) {
    final ticket = _getOrCreate(userId);
    _tickets[userId] = ticket.copyWith(count: ticket.count + count);
  }
}
