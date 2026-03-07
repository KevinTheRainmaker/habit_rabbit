import 'package:habit_rabbit/domain/entities/notification_settings.dart';
import 'package:habit_rabbit/domain/services/notification_service.dart';

class InMemoryNotificationService implements NotificationService {
  final Set<String> scheduledIds = {};

  @override
  Future<void> scheduleDaily({
    required String id,
    required NotificationSettings settings,
    required String title,
    required String body,
  }) async {
    if (!settings.isEnabled) return;
    scheduledIds.add(id);
  }

  @override
  Future<void> cancel({required String id}) async {
    scheduledIds.remove(id);
  }
}
