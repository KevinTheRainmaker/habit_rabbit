import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/entities/recovery_ticket.dart';
import 'package:habit_rabbit/domain/repositories/recovery_repository.dart';

class HiveRecoveryRepository implements RecoveryRepository {
  final Box _box;

  HiveRecoveryRepository(this._box);

  String _key(String userId) => 'recovery_$userId';

  RecoveryTicket _decode(Map map) => RecoveryTicket(
        count: (map['count'] as int?) ?? 0,
        freeTrialUsed: (map['freeTrialUsed'] as bool?) ?? false,
      );

  Map<String, dynamic> _encode(RecoveryTicket ticket) => {
        'count': ticket.count,
        'freeTrialUsed': ticket.freeTrialUsed,
      };

  @override
  Future<RecoveryTicket> getTicket({required String userId}) async {
    final raw = _box.get(_key(userId));
    if (raw == null) return const RecoveryTicket(count: 0, freeTrialUsed: false);
    return _decode(raw as Map);
  }

  @override
  Future<void> useTicket({required String userId}) async {
    final ticket = await getTicket(userId: userId);
    if (ticket.count <= 0) throw Exception('티켓이 없습니다');
    await _box.put(_key(userId), _encode(ticket.copyWith(count: ticket.count - 1)));
  }

  @override
  Future<void> useFreeTrial({required String userId}) async {
    final ticket = await getTicket(userId: userId);
    await _box.put(_key(userId), _encode(ticket.copyWith(freeTrialUsed: true)));
  }
}
