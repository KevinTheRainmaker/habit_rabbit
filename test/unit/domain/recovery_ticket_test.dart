import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/recovery_ticket.dart';

void main() {
  group('RecoveryTicket', () {
    test('기본 무료 티켓 1개, 체험 미사용', () {
      const ticket = RecoveryTicket(count: 1, freeTrialUsed: false);
      expect(ticket.count, equals(1));
      expect(ticket.freeTrialUsed, isFalse);
    });

    test('canUse: count > 0이면 true', () {
      const ticket = RecoveryTicket(count: 1, freeTrialUsed: false);
      expect(ticket.canUse, isTrue);
    });

    test('canUse: count == 0이면 false', () {
      const ticket = RecoveryTicket(count: 0, freeTrialUsed: false);
      expect(ticket.canUse, isFalse);
    });

    test('canUseFreeTrial: freeTrialUsed false이면 true', () {
      const ticket = RecoveryTicket(count: 0, freeTrialUsed: false);
      expect(ticket.canUseFreeTrial, isTrue);
    });

    test('canUseFreeTrial: freeTrialUsed true이면 false', () {
      const ticket = RecoveryTicket(count: 0, freeTrialUsed: true);
      expect(ticket.canUseFreeTrial, isFalse);
    });

    test('copyWith으로 count 감소', () {
      const ticket = RecoveryTicket(count: 3, freeTrialUsed: false);
      final used = ticket.copyWith(count: ticket.count - 1);
      expect(used.count, equals(2));
    });

    test('같은 값은 동일하다', () {
      const a = RecoveryTicket(count: 1, freeTrialUsed: false);
      const b = RecoveryTicket(count: 1, freeTrialUsed: false);
      expect(a, equals(b));
    });
  });
}
