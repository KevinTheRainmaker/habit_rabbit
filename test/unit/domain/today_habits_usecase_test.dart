import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/usecases/today_habits_usecase.dart';

void main() {
  late TodayHabitsUseCase useCase;

  setUp(() {
    useCase = TodayHabitsUseCase();
  });

  // 2026-03-07은 토요일 (weekday=6, 0=월~6=일 기준으로 targetDays에서 6=일요일 아님)
  // Dart의 weekday: 1=월, 2=화, ..., 6=토, 7=일
  // 우리 targetDays: 0=월, 1=화, ..., 5=토, 6=일
  // 2026-03-07 토요일 → targetDays index = weekday - 1 = 5

  group('TodayHabitsUseCase', () {
    test('매일 설정된 습관은 항상 반환', () {
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
        // targetDays 기본값 [0,1,2,3,4,5,6]
      );
      final today = DateTime(2026, 3, 7); // 토요일

      final result = useCase.call(habits: [habit], today: today);

      expect(result, contains(habit));
    });

    test('오늘 요일이 포함된 습관만 반환', () {
      // 2026-03-07 토요일 → index 5
      final habitSat = Habit(
        id: 'h-1', userId: 'uid-1', name: '토요일 운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
        targetDays: [5], // 토요일만
      );
      final habitSun = Habit(
        id: 'h-2', userId: 'uid-1', name: '일요일 운동',
        createdAt: DateTime(2026, 3, 7), isActive: true,
        targetDays: [6], // 일요일만
      );
      final today = DateTime(2026, 3, 7); // 토요일

      final result = useCase.call(habits: [habitSat, habitSun], today: today);

      expect(result, contains(habitSat));
      expect(result, isNot(contains(habitSun)));
    });

    test('오늘 요일에 해당하지 않는 습관은 제외', () {
      final habit = Habit(
        id: 'h-1', userId: 'uid-1', name: '월요일 습관',
        createdAt: DateTime(2026, 3, 7), isActive: true,
        targetDays: [0], // 월요일만
      );
      final today = DateTime(2026, 3, 7); // 토요일

      final result = useCase.call(habits: [habit], today: today);

      expect(result, isEmpty);
    });
  });
}
