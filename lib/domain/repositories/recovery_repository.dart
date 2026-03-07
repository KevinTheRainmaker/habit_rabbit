import 'package:habit_rabbit/domain/entities/recovery_ticket.dart';

abstract class RecoveryRepository {
  Future<RecoveryTicket> getTicket({required String userId});
  Future<void> useTicket({required String userId});
  Future<void> useFreeTrial({required String userId});
}
