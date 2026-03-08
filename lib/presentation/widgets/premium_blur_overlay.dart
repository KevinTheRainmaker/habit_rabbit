import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumBlurOverlay extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onUpgrade;
  final Widget child;

  const PremiumBlurOverlay({
    super.key,
    required this.isPremium,
    required this.onUpgrade,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.white.withValues(alpha: 0.6),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '구독하면 이런 인사이트를 받을 수 있어요',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onUpgrade,
                      child: const Text('업그레이드하기'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
