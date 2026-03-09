import 'package:flutter/material.dart';

const _dayLabels = ['월', '화', '수', '목', '금', '토', '일'];
const _icons = ['🏃', '📚', '💧', '🧘', '🎯', '💪', '🍎', '😴', '✍️', '🎨'];

class AddHabitDialog extends StatefulWidget {
  final void Function(String name, List<int> targetDays, String icon)? onSaved;

  const AddHabitDialog({super.key, this.onSaved});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _controller = TextEditingController();
  String? _errorText;
  String? _daysErrorText;
  // 0=월 ~ 6=일, 기본: 전체 선택
  final Set<int> _selectedDays = {0, 1, 2, 3, 4, 5, 6};
  String _selectedIcon = '';

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
      setState(() { _errorText = '습관 이름을 입력해주세요'; _daysErrorText = null; });
      return;
    }
    if (_selectedDays.isEmpty) {
      setState(() { _errorText = null; _daysErrorText = '최소 하나의 요일을 선택해주세요'; });
      return;
    }
    setState(() { _errorText = null; _daysErrorText = null; });
    final days = _selectedDays.toList()..sort();
    widget.onSaved?.call(name, days, _selectedIcon);
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
            '새 습관 추가',
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
          const SizedBox(height: 12),
          const Text('아이콘 선택', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _icons.map((icon) {
                final selected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(icon, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('반복 요일', style: TextStyle(fontWeight: FontWeight.w500)),
          if (_daysErrorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _daysErrorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
              ),
            ),
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
