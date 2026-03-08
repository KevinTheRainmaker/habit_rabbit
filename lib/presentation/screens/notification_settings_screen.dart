import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/presentation/providers/notification_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('알림 활성화'),
            value: settings.isEnabled,
            onChanged: (value) {
              ref.read(notificationSettingsProvider.notifier).state =
                  settings.copyWith(isEnabled: value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('저장되었습니다')),
              );
            },
          ),
          ListTile(
            title: const Text('알림 시간'),
            subtitle: Text(
              '${settings.hour.toString().padLeft(2, '0')}:'
              '${settings.minute.toString().padLeft(2, '0')}',
            ),
            trailing: const Icon(Icons.access_time),
            enabled: settings.isEnabled,
            onTap: settings.isEnabled
                ? () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: settings.hour,
                        minute: settings.minute,
                      ),
                    );
                    if (picked != null) {
                      ref.read(notificationSettingsProvider.notifier).state =
                          settings.copyWith(
                        hour: picked.hour,
                        minute: picked.minute,
                      );
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
