import 'package:flutter/material.dart';

class StreakBreakDialog extends StatelessWidget {
  final bool freeTrialUsed;
  final VoidCallback onUseFreeRecovery;
  final VoidCallback onRestart;

  const StreakBreakDialog({
    super.key,
    required this.freeTrialUsed,
    required this.onUseFreeRecovery,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('괜찮아, 누구나 실수할 수 있어'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: freeTrialUsed ? null : onUseFreeRecovery,
          child: const Text('무료 복구권 사용하기'),
        ),
        TextButton(
          onPressed: onRestart,
          child: const Text('괜찮아, 다시 시작할게'),
        ),
      ],
    );
  }
}
