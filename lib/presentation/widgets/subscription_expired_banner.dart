import 'package:flutter/material.dart';

class SubscriptionExpiredBanner extends StatelessWidget {
  final bool isPremium;
  final bool wasEverPremium;
  final VoidCallback? onRenew;

  const SubscriptionExpiredBanner({
    super.key,
    required this.isPremium,
    required this.wasEverPremium,
    required this.onRenew,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium || !wasEverPremium) return const SizedBox.shrink();

    return MaterialBanner(
      content: const Text('구독이 만료되었어요. 유료 기능이 비활성화됩니다.'),
      actions: [
        TextButton(
          onPressed: onRenew,
          child: const Text('다시 구독하기'),
        ),
      ],
    );
  }
}
