import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class CheckInUseCase {
  final HabitRepository _repository;

  CheckInUseCase(this._repository);

  Future<Checkin> call({
    required String habitId,
    required String userId,
    required DateTime date,
  }) {
    return _repository.checkIn(habitId: habitId, userId: userId, date: date);
  }
}
