import 'package:flutter/material.dart';

class PremiumTeaserBanner extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onUpgrade;

  const PremiumTeaserBanner({
    super.key,
    required this.isPremium,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.amber.shade50,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '구독하면 더 많은 인사이트를 받을 수 있어요',
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onUpgrade,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('업그레이드하기'),
          ),
        ],
      ),
    );
  }
}
