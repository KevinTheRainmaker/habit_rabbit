import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';
import 'package:habit_rabbit/domain/services/notification_service.dart';
import 'package:habit_rabbit/data/services/in_memory_notification_service.dart';

void main() {
  group('InMemoryNotificationService', () {
    test('NotificationService를 구현한다', () {
      final service = InMemoryNotificationService();
      expect(service, isA<NotificationService>());
    });

    test('알림 예약 후 예약 목록에 포함', () async {
      final service = InMemoryNotificationService();
      const settings = NotificationSettings(hour: 9, minute: 0);

      await service.scheduleDaily(id: 'habit-1', settings: settings, title: '테스트', body: '메시지');

      expect(service.scheduledIds.contains('habit-1'), isTrue);
    });

    test('알림 취소 후 예약 목록에서 제거', () async {
      final service = InMemoryNotificationService();
      const settings = NotificationSettings(hour: 9, minute: 0);

      await service.scheduleDaily(id: 'habit-1', settings: settings, title: '테스트', body: '메시지');
      await service.cancel(id: 'habit-1');

      expect(service.scheduledIds.contains('habit-1'), isFalse);
    });

    test('isEnabled false면 알림 예약 안 됨', () async {
      final service = InMemoryNotificationService();
      const settings = NotificationSettings(hour: 9, minute: 0, isEnabled: false);

      await service.scheduleDaily(id: 'habit-1', settings: settings, title: '테스트', body: '메시지');

      expect(service.scheduledIds.contains('habit-1'), isFalse);
    });
  });
}
