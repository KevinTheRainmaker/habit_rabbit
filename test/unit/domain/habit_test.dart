import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';

void main() {
  group('Habit entity', () {
    test('같은 id를 가지면 동일하다', () {
      final habit1 = Habit(
        id: 'habit-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: true,
      );
      final habit2 = Habit(
        id: 'habit-1',
        userId: 'uid-1',
        name: '다른 이름',
        createdAt: DateTime(2026, 3, 8),
        isActive: false,
      );

      expect(habit1, equals(habit2));
    });

    test('isActive false인 습관은 비활성 상태', () {
      final habit = Habit(
        id: 'habit-1',
        userId: 'uid-1',
        name: '운동',
        createdAt: DateTime(2026, 3, 7),
        isActive: false,
      );

      expect(habit.isActive, isFalse);
    });
  });
}
