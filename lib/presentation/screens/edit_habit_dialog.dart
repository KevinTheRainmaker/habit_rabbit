import 'package:flutter/material.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

const _dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

class EditHabitDialog extends StatefulWidget {
  final Habit habit;
  final void Function(String name, List<int> targetDays)? onSaved;

  const EditHabitDialog({super.key, required this.habit, this.onSaved});

  @override
  State<EditHabitDialog> createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  late final TextEditingController _controller;
  String? _errorText;
  late final Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.habit.name);
    _selectedDays = Set<int>.from(widget.habit.targetDays);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _onSave() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = '습관 이름을 입력해주세요');
      return;
    }
    setState(() => _errorText = null);
    final days = _selectedDays.toList()..sort();
    widget.onSaved?.call(name, days);
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
          const Text('반복 요일', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_dayLabels.length, (i) {
              final day = i;
              final selected = _selectedDays.contains(day);
              return GestureDetector(
                onTap: () => _toggleDay(day),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade200,
                  child: Text(
                    _dayLabels[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              );
            }),
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
