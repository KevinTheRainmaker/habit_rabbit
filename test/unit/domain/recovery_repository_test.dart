import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/data/repositories/in_memory_recovery_repository.dart';
import 'package:habit_rabbit/domain/repositories/recovery_repository.dart';

void main() {
  group('InMemoryRecoveryRepository', () {
    test('RecoveryRepository를 구현한다', () {
      expect(InMemoryRecoveryRepository(), isA<RecoveryRepository>());
    });

    test('초기 티켓: count=0, freeTrialUsed=false', () async {
      final repo = InMemoryRecoveryRepository();
      final ticket = await repo.getTicket(userId: 'u-1');
      expect(ticket.count, equals(0));
      expect(ticket.freeTrialUsed, isFalse);
    });

    test('useFreeTrial 후 freeTrialUsed=true', () async {
      final repo = InMemoryRecoveryRepository();
      await repo.useFreeTrial(userId: 'u-1');
      final ticket = await repo.getTicket(userId: 'u-1');
      expect(ticket.freeTrialUsed, isTrue);
    });

    test('useTicket 후 count 감소', () async {
      final repo = InMemoryRecoveryRepository();
      // 티켓 추가 후 사용
      repo.addTicket(userId: 'u-1', count: 2);
      await repo.useTicket(userId: 'u-1');
      final ticket = await repo.getTicket(userId: 'u-1');
      expect(ticket.count, equals(1));
    });

    test('티켓 없이 useTicket 시 예외', () async {
      final repo = InMemoryRecoveryRepository();
      expect(
        () => repo.useTicket(userId: 'u-1'),
        throwsException,
      );
    });
  });
}
