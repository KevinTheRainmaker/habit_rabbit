import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_recovery_repository.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveRecoveryRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_recovery_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('recovery_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveRecoveryRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveRecoveryRepository', () {
    test('초기 티켓은 count=0, freeTrialUsed=false', () async {
      final ticket = await repo.getTicket(userId: 'u1');
      expect(ticket.count, 0);
      expect(ticket.freeTrialUsed, false);
    });

    test('useFreeTrial 후 freeTrialUsed=true', () async {
      await repo.useFreeTrial(userId: 'u1');
      final ticket = await repo.getTicket(userId: 'u1');
      expect(ticket.freeTrialUsed, true);
    });

    test('티켓 없을 때 useTicket 예외', () async {
      expect(
        () => repo.useTicket(userId: 'u1'),
        throwsException,
      );
    });

    test('Box 재생성 후 freeTrialUsed 영속', () async {
      await repo.useFreeTrial(userId: 'u1');
      final repo2 = HiveRecoveryRepository(box);
      final ticket = await repo2.getTicket(userId: 'u1');
      expect(ticket.freeTrialUsed, true);
    });

    test('서로 다른 userId는 독립적', () async {
      await repo.useFreeTrial(userId: 'u1');
      final ticket2 = await repo.getTicket(userId: 'u2');
      expect(ticket2.freeTrialUsed, false);
    });
  });
}
