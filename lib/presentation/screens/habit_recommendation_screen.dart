import 'package:flutter/material.dart';
import 'package:habit_rabbit/domain/usecases/habit_recommendation_usecase.dart';

class HabitRecommendationScreen extends StatefulWidget {
  final void Function(List<String> selectedHabits) onStart;
  final List<String> answers;

  const HabitRecommendationScreen({
    super.key,
    required this.onStart,
    this.answers = const [],
  });

  @override
  State<HabitRecommendationScreen> createState() =>
      _HabitRecommendationScreenState();
}

class _HabitRecommendationScreenState
    extends State<HabitRecommendationScreen> {
  final Set<String> _selected = {};

  List<String> get _recommendations =>
      HabitRecommendationUseCase(answers: widget.answers).recommendations;

  @override
  Widget build(BuildContext context) {
    final recommendations = _recommendations;

    return Scaffold(
      appBar: AppBar(title: const Text('추천 습관')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '오늘은 1개만 시작해요',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '오늘부터 시작할 습관을 골라보세요',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_selected.length == 1)
              const Text('완벽한 시작이에요!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            if (_selected.length >= 2)
              const Text('처음엔 적을수록 좋아요',
                  style: TextStyle(color: Colors.orange)),
            if (_selected.isNotEmpty) const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final habit = recommendations[index];
                  return CheckboxListTile(
                    title: Text(habit),
                    value: _selected.contains(habit),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selected.add(habit);
                        } else {
                          _selected.remove(habit);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onStart(_selected.toList()),
                child: const Text('시작하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
