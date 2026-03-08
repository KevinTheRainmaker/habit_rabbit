import 'package:hive/hive.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';

class HiveNotificationRepository {
  final Box _box;

  static const _hourKey = 'notif_hour';
  static const _minuteKey = 'notif_minute';
  static const _enabledKey = 'notif_enabled';

  HiveNotificationRepository(this._box);

  Future<NotificationSettings> loadSettings() async {
    final hour = _box.get(_hourKey) as int? ?? 9;
    final minute = _box.get(_minuteKey) as int? ?? 0;
    final isEnabled = _box.get(_enabledKey) as bool? ?? true;
    return NotificationSettings(hour: hour, minute: minute, isEnabled: isEnabled);
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    await _box.put(_hourKey, settings.hour);
    await _box.put(_minuteKey, settings.minute);
    await _box.put(_enabledKey, settings.isEnabled);
  }
}
