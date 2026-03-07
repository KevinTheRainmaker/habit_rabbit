import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';
import 'package:habit_rabbit/data/repositories/in_memory_habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return InMemoryHabitRepository();
});

final habitListProvider = FutureProvider.family<List<Habit>, String>((ref, userId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabits(userId: userId);
});
