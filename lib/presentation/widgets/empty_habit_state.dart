import 'package:flutter/material.dart';

class EmptyHabitState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyHabitState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            '아직 등록된 습관이 없어요',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            '작은 습관 하나로 시작해보세요',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAdd,
            child: const Text('첫 습관 추가하기'),
          ),
        ],
      ),
    );
  }
}
