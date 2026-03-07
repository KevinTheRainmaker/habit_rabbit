import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: HabitRabbitApp()));
}

class HabitRabbitApp extends StatelessWidget {
  const HabitRabbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Rabbit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
        ),
        useMaterial3: true,
      ),
      home: const HabitListScreen(),
    );
  }
}
