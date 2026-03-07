import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository _repository;

  DeleteHabitUseCase(this._repository);

  Future<void> call({required String habitId, required String userId}) {
    return _repository.deleteHabit(habitId: habitId, userId: userId);
  }
}
