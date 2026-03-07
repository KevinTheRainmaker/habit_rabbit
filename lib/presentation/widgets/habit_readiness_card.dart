import 'package:flutter/material.dart';

class HabitReadinessCard extends StatelessWidget {
  final double weeklyCompletionRate;
  final VoidCallback onAdd;
  final VoidCallback onDismiss;

  const HabitReadinessCard({
    super.key,
    required this.weeklyCompletionRate,
    required this.onAdd,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '습관 하나 더 추가할 준비됐어요?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '이번 주 달성률 ${(weeklyCompletionRate * 100).toStringAsFixed(0)}% — 잘하고 있어요!',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onDismiss,
                  child: const Text('아직은 괜찮아'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onAdd,
                  child: const Text('추가하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
