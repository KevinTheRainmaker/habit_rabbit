import 'package:flutter/material.dart';

class CompletionRateCard extends StatelessWidget {
  final double rate;
  final int currentStreak;

  const CompletionRateCard({super.key, required this.rate, this.currentStreak = -1});

  @override
  Widget build(BuildContext context) {
    final percent = (rate * 100).round();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: rate == 0.0
            ? const Text('오늘 첫 체크인을 해보세요!')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이번 달 달성률',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$percent%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: rate),
                  if (rate >= 0.7) ...[
                    const SizedBox(height: 8),
                    if (currentStreak == 0)
                      Text('이번 달 ${(rate * 100).round()}% 달성했어, 잘하고 있어!')
                    else
                      const Text('잘하고 있어!'),
                  ],
                ],
              ),
      ),
    );
  }
}
