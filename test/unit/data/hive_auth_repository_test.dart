import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_auth_repository.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveAuthRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_auth_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('auth_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveAuthRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveAuthRepository', () {
    test('초기에는 currentUser stream에서 null 반환', () async {
      final user = await repo.currentUser.first;
      expect(user, isNull);
    });

    test('signInAsGuest 후 currentUser에서 guest 유저 반환', () async {
      await repo.signInAsGuest();
      final user = await repo.currentUser.first;
      expect(user, isNotNull);
      expect(user!.id, 'guest-uid');
    });

    test('signOut 후 currentUser가 null', () async {
      await repo.signInAsGuest();
      await repo.signOut();
      final user = await repo.currentUser.first;
      expect(user, isNull);
    });

    test('재생성 후에도 마지막 로그인 유저 복원', () async {
      await repo.signInAsGuest();
      final repo2 = HiveAuthRepository(box);
      final user = await repo2.currentUser.first;
      expect(user, isNotNull);
      expect(user!.id, 'guest-uid');
    });

    test('signOut 후 재생성하면 null', () async {
      await repo.signInAsGuest();
      await repo.signOut();
      final repo2 = HiveAuthRepository(box);
      final user = await repo2.currentUser.first;
      expect(user, isNull);
    });
  });
}
