import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/repositories/in_memory_habit_repository.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return InMemoryHabitRepository();
});

// 읽기 전용 (기존 호환 유지)
final habitListProvider = FutureProvider.family<List<Habit>, String>((ref, userId) async {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabits(userId: userId);
});

// 쓰기 가능한 Notifier 버전
class HabitListNotifier extends FamilyAsyncNotifier<List<Habit>, String> {
  @override
  Future<List<Habit>> build(String arg) async {
    final repo = ref.watch(habitRepositoryProvider);
    return repo.getHabits(userId: arg);
  }

  Future<void> addHabit({required String name, required String userId}) async {
    final repo = ref.read(habitRepositoryProvider);
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: name,
      createdAt: DateTime.now(),
      isActive: true,
    );
    await repo.addHabit(habit);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, habit]);
  }
}

final habitListNotifierProvider =
    AsyncNotifierProvider.family<HabitListNotifier, List<Habit>, String>(
  HabitListNotifier.new,
);
