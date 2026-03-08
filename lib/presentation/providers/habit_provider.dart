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

  Future<void> addHabit({required String name, required String userId, List<int>? targetDays, String icon = ''}) async {
    final repo = ref.read(habitRepositoryProvider);
    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: name,
      createdAt: DateTime.now(),
      isActive: true,
      targetDays: targetDays ?? const [0, 1, 2, 3, 4, 5, 6],
      icon: icon,
    );
    await repo.addHabit(habit);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, habit]);
  }

  Future<void> updateHabit(Habit habit) async {
    final repo = ref.read(habitRepositoryProvider);
    await repo.updateHabit(habit);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.map((h) => h.id == habit.id ? habit : h).toList());
  }

  Future<void> deleteHabit({required String habitId, required String userId}) async {
    final repo = ref.read(habitRepositoryProvider);
    await repo.deleteHabit(habitId: habitId, userId: userId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((h) => h.id != habitId).toList());
  }
}

final habitListNotifierProvider =
    AsyncNotifierProvider.family<HabitListNotifier, List<Habit>, String>(
  HabitListNotifier.new,
);
