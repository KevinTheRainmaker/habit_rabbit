import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/presentation/providers/notification_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  final bool isPremium;

  const NotificationSettingsScreen({super.key, this.isPremium = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '🥕 당근이 기다리고 있어요! 알림을 설정하면 습관을 잊지 않을 수 있어요.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
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
          if (!isPremium)
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('요일별 알림 세분화'),
              subtitle: const Text('유료 전용 기능이에요'),
              enabled: false,
            ),
          if (isPremium) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('요일별 알림 시간', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (final day in ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'])
              ListTile(
                title: Text(day),
                trailing: const Text('09:00'),
                onTap: () {},
              ),
          ],
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
