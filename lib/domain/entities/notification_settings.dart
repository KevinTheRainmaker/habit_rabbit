import 'package:equatable/equatable.dart';

class NotificationSettings extends Equatable {
  final int hour;
  final int minute;
  final bool isEnabled;

  const NotificationSettings({
    required this.hour,
    required this.minute,
    this.isEnabled = true,
  });

  factory NotificationSettings.defaultSettings() =>
      const NotificationSettings(hour: 9, minute: 0);

  NotificationSettings copyWith({
    int? hour,
    int? minute,
    bool? isEnabled,
  }) =>
      NotificationSettings(
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        isEnabled: isEnabled ?? this.isEnabled,
      );

  @override
  List<Object> get props => [hour, minute, isEnabled];
}
