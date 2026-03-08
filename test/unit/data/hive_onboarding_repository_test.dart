import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_onboarding_repository.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveOnboardingRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_onboarding_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('onb_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveOnboardingRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveOnboardingRepository', () {
    test('초기에는 완료되지 않음(false) 반환', () async {
      final result = await repo.isCompleted();
      expect(result, isFalse);
    });

    test('완료 저장 후 true 반환', () async {
      await repo.setCompleted();
      final result = await repo.isCompleted();
      expect(result, isTrue);
    });

    test('재생성 후에도 완료 상태 복원', () async {
      await repo.setCompleted();
      final repo2 = HiveOnboardingRepository(box);
      final result = await repo2.isCompleted();
      expect(result, isTrue);
    });

    test('reset 후 false 반환', () async {
      await repo.setCompleted();
      await repo.reset();
      final result = await repo.isCompleted();
      expect(result, isFalse);
    });
  });
}
