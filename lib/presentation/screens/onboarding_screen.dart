import 'package:flutter/material.dart';

const _questions = [
  _Question(
    text: '어떤 목표를 이루고 싶으신가요?',
    options: ['건강한 몸 만들기', '마음의 여유 찾기', '생산성 높이기', '새로운 습관 배우기'],
  ),
  _Question(
    text: '주로 언제 루틴을 실천하시나요?',
    options: ['아침 (기상 후)', '점심 (식사 전후)', '저녁 (퇴근 후)', '취침 전'],
  ),
  _Question(
    text: '습관 트래킹 경험이 있으신가요?',
    options: ['처음이에요', '앱을 써봤지만 지속이 어려웠어요', '꾸준히 해봤어요', '전문가 수준이에요'],
  ),
];

class _Question {
  final String text;
  final List<String> options;

  const _Question({required this.text, required this.options});
}

class OnboardingScreen extends StatefulWidget {
  final void Function(List<String> answers) onCompleted;
  final VoidCallback onSkip;

  const OnboardingScreen({
    super.key,
    required this.onCompleted,
    required this.onSkip,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final List<String?> _answers = List.filled(_questions.length, null);

  void _onNext() {
    if (_currentPage < _questions.length - 1) {
      setState(() => _currentPage++);
    } else {
      widget.onCompleted(
        _answers.map((a) => a ?? '').toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentPage];
    final isLast = _currentPage == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: widget.onSkip,
            child: const Text('건너뛰기'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_currentPage + 1} / ${_questions.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              question.text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _answers[_currentPage] == option;
                  return ListTile(
                    title: Text(option),
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    ),
                    onTap: () => setState(() => _answers[_currentPage] = option),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _answers[_currentPage] != null ? _onNext : null,
                child: Text(isLast ? '완료' : '다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
