import 'package:flutter/material.dart';

class PremiumGateScreen extends StatelessWidget {
  const PremiumGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🐰 프리미엄으로 업그레이드',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            '무료 플랜에서는 습관을 최대 3개까지 추가할 수 있어요.\n'
            '프리미엄으로 업그레이드하면 더 많은 혜택을 누릴 수 있어요!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _FeatureRow(free: '최대 3개', premium: '무제한', label: '습관 수'),
          _FeatureRow(free: '기본', premium: '심화 통계', label: '통계'),
          _FeatureRow(free: '1회 무료 체험', premium: '매월 1개 자동 지급', label: '복구권'),
          _FeatureRow(free: '기본 아이템', premium: '프리미엄 아이템', label: '아이템'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🐰 프리미엄 토끼가 됐어요!')),
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
            ),
            child: const Text('업그레이드하기'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('나중에'),
          ),
          TextButton(
            onPressed: () {
              // TODO: RevenueCat 구독 복원 연결
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('구독 복원 중...')),
              );
            },
            child: const Text('구독 복원하기'),
          ),
        ],
      ),
    );
  }
}


class _FeatureRow extends StatelessWidget {
  final String label;
  final String free;
  final String premium;

  const _FeatureRow({
    required this.label,
    required this.free,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text(free, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))),
          Expanded(flex: 2, child: Text(premium, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFF6B35)))),
        ],
      ),
    );
  }
}
