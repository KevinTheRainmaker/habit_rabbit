import 'package:habit_rabbit/domain/entities/notification_settings.dart';

abstract class NotificationService {
  Future<void> scheduleDaily({
    required String id,
    required NotificationSettings settings,
    required String title,
    required String body,
  });

  Future<void> cancel({required String id});
}
