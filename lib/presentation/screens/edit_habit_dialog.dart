import 'package:flutter/material.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

class EditHabitDialog extends StatefulWidget {
  final Habit habit;
  final void Function(String name)? onSaved;

  const EditHabitDialog({super.key, required this.habit, this.onSaved});

  @override
  State<EditHabitDialog> createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.habit.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = '습관 이름을 입력해주세요');
      return;
    }
    setState(() => _errorText = null);
    widget.onSaved?.call(name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '습관 편집',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '습관 이름',
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onSave,
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
