import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';

void main() {
  group('NotificationSettings', () {
    test('기본 알림 시간은 오전 9시', () {
      final settings = NotificationSettings.defaultSettings();
      expect(settings.hour, equals(9));
      expect(settings.minute, equals(0));
    });

    test('같은 설정은 동일하다', () {
      const a = NotificationSettings(hour: 8, minute: 30);
      const b = NotificationSettings(hour: 8, minute: 30);
      expect(a, equals(b));
    });

    test('다른 시간은 다르다', () {
      const a = NotificationSettings(hour: 8, minute: 0);
      const b = NotificationSettings(hour: 9, minute: 0);
      expect(a, isNot(equals(b)));
    });

    test('copyWith으로 시간 변경', () {
      const settings = NotificationSettings(hour: 9, minute: 0);
      final updated = settings.copyWith(hour: 20, minute: 30);
      expect(updated.hour, equals(20));
      expect(updated.minute, equals(30));
    });

    test('isEnabled 기본값 true', () {
      final settings = NotificationSettings.defaultSettings();
      expect(settings.isEnabled, isTrue);
    });
  });
}
