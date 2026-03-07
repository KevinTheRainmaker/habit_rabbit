import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/services/in_memory_notification_service.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';
import 'package:habit_rabbit/domain/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => InMemoryNotificationService(),
);

final notificationSettingsProvider =
    StateProvider<NotificationSettings>(
  (ref) => NotificationSettings.defaultSettings(),
);
