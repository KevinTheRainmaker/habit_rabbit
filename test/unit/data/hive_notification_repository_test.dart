import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_rabbit/data/repositories/hive_notification_repository.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';

void main() {
  late Box box;
  late Directory tempDir;
  late HiveNotificationRepository repo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_notif_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('notif_${DateTime.now().millisecondsSinceEpoch}');
    repo = HiveNotificationRepository(box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  group('HiveNotificationRepository', () {
    test('초기에는 기본 설정(9시 0분, 활성화) 반환', () async {
      final settings = await repo.loadSettings();
      expect(settings.hour, 9);
      expect(settings.minute, 0);
      expect(settings.isEnabled, true);
    });

    test('저장 후 로드하면 저장된 설정 반환', () async {
      const saved = NotificationSettings(hour: 20, minute: 30, isEnabled: true);
      await repo.saveSettings(saved);
      final loaded = await repo.loadSettings();
      expect(loaded.hour, 20);
      expect(loaded.minute, 30);
      expect(loaded.isEnabled, true);
    });

    test('재생성 후에도 마지막 설정 복원', () async {
      const saved = NotificationSettings(hour: 7, minute: 15, isEnabled: true);
      await repo.saveSettings(saved);
      final repo2 = HiveNotificationRepository(box);
      final loaded = await repo2.loadSettings();
      expect(loaded.hour, 7);
      expect(loaded.minute, 15);
    });

    test('isEnabled false 저장 후 로드', () async {
      const saved = NotificationSettings(hour: 9, minute: 0, isEnabled: false);
      await repo.saveSettings(saved);
      final loaded = await repo.loadSettings();
      expect(loaded.isEnabled, false);
    });
  });
}
