import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Google 로그인 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Google로 시작하기'), findsOneWidget);
    });

    testWidgets('Apple 로그인 버튼 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Apple로 시작하기'), findsOneWidget);
    });

    testWidgets('토끼굴 앱 이름 표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Habit Rabbit'), findsOneWidget);
    });

    testWidgets('게스트로 시작 버튼 존재', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('게스트로 시작'), findsOneWidget);
    });

    testWidgets('게스트 버튼 탭 시 onGuestLogin 콜백 호출', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(onGuestLogin: () => called = true),
          ),
        ),
      );

      await tester.tap(find.text('게스트로 시작'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('Google 버튼 탭 시 onGoogleLogin 콜백 호출', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(onGoogleLogin: () => called = true),
          ),
        ),
      );

      await tester.tap(find.text('Google로 시작하기'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('Apple 버튼 탭 시 onAppleLogin 콜백 호출', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(onAppleLogin: () => called = true),
          ),
        ),
      );

      await tester.tap(find.text('Apple로 시작하기'));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });
  });
}
