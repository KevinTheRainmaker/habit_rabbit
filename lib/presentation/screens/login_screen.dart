import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  final VoidCallback? onGuestLogin;
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;

  const LoginScreen({super.key, this.onGuestLogin, this.onGoogleLogin, this.onAppleLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Habit Rabbit',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: onGoogleLogin,
                child: const Text('Google로 시작하기'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAppleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apple로 시작하기'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onGuestLogin,
                child: const Text('게스트로 시작'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
