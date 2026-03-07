import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';
import 'package:habit_rabbit/domain/services/notification_service.dart';
import 'package:habit_rabbit/presentation/providers/notification_provider.dart';

void main() {
  group('notificationProvider', () {
    test('notificationServiceProvider는 NotificationService를 반환한다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(notificationServiceProvider);
      expect(service, isA<NotificationService>());
    });

    test('notificationSettingsProvider 기본값은 defaultSettings', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final settings = container.read(notificationSettingsProvider);
      expect(settings.hour, equals(9));
      expect(settings.minute, equals(0));
      expect(settings.isEnabled, isTrue);
    });

    test('notificationSettingsProvider 업데이트 가능', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(notificationSettingsProvider.notifier).state =
          const NotificationSettings(hour: 20, minute: 30);

      final settings = container.read(notificationSettingsProvider);
      expect(settings.hour, equals(20));
      expect(settings.minute, equals(30));
    });
  });
}
