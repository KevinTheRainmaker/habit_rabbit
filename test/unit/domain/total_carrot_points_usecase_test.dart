import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/usecases/total_carrot_points_usecase.dart';

void main() {
  group('TotalCarrotPointsUseCase', () {
    test('빈 체크인 목록이면 0 반환', () {
      final useCase = TotalCarrotPointsUseCase(checkins: []);
      expect(useCase.total, 0);
    });

    test('단일 체크인의 carrotPoints 반환', () {
      final checkin = Checkin(
        id: '1',
        habitId: 'h1',
        userId: 'u1',
        date: DateTime(2026, 3, 1),
        streakDay: 1,
      );
      final useCase = TotalCarrotPointsUseCase(checkins: [checkin]);
      expect(useCase.total, checkin.carrotPoints);
    });

    test('여러 체크인의 carrotPoints 합산', () {
      final checkins = [
        Checkin(
          id: '1',
          habitId: 'h1',
          userId: 'u1',
          date: DateTime(2026, 3, 1),
          streakDay: 1,
        ),
        Checkin(
          id: '2',
          habitId: 'h1',
          userId: 'u1',
          date: DateTime(2026, 3, 2),
          streakDay: 2,
        ),
        Checkin(
          id: '3',
          habitId: 'h1',
          userId: 'u1',
          date: DateTime(2026, 3, 3),
          streakDay: 3,
        ),
      ];
      final useCase = TotalCarrotPointsUseCase(checkins: checkins);
      final expected = checkins.fold(0, (sum, c) => sum + c.carrotPoints);
      expect(useCase.total, expected);
    });
  });
}
