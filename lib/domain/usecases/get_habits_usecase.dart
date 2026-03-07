import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository _repository;

  GetHabitsUseCase(this._repository);

  Future<List<Habit>> call({
    required String userId,
    bool includeInactive = false,
  }) async {
    final habits = await _repository.getHabits(userId: userId);
    if (includeInactive) return habits;
    return habits.where((h) => h.isActive).toList();
  }
}
