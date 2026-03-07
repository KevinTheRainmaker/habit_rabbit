import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository _repository;

  AddHabitUseCase(this._repository);

  /// [isPremium] 기본값 true — 명시적으로 false 전달 시 무료 한도(3개) 적용
  Future<Habit> call(Habit habit, {bool isPremium = true}) async {
    if (!isPremium) {
      final existing = await _repository.getHabits(userId: habit.userId);
      if (existing.length >= 3) {
        throw Exception('무료 플랜은 습관을 최대 3개까지 추가할 수 있습니다.');
      }
    }
    return _repository.addHabit(habit);
  }
}
