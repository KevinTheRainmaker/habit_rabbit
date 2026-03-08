import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/notification_settings.dart';
import 'package:habit_rabbit/presentation/providers/notification_provider.dart';
import 'package:habit_rabbit/presentation/screens/notification_settings_screen.dart';

void main() {
  group('NotificationSettingsScreen', () {
    testWidgets('알림 활성화 토글 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('현재 알림 시간 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // 기본 설정: 오전 9:00
      expect(find.textContaining('9'), findsWidgets);
    });

    testWidgets('토글 비활성화 시 설정 업데이트', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: NotificationSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Switch를 탭하여 비활성화
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      final settings = container.read(notificationSettingsProvider);
      expect(settings.isEnabled, isFalse);
    });

    testWidgets('앱바에 "알림 설정" 타이틀 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('알림 설정'), findsOneWidget);
    });

    testWidgets('알림 설정 화면에 토끼 알림 문구 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('당근이 기다리고 있어요'), findsOneWidget);
    });

    testWidgets('알림 토글 변경 시 저장 메시지 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationSettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.textContaining('저장'), findsOneWidget);
    });
  });
}
