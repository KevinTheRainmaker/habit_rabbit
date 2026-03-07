import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/usecases/monthly_completion_rate_usecase.dart';

void main() {
  late MonthlyCompletionRateUseCase useCase;

  setUp(() {
    useCase = MonthlyCompletionRateUseCase();
  });

  group('MonthlyCompletionRateUseCase', () {
    test('체크인 없으면 0.0 반환', () {
      final rate = useCase.call(
        checkins: [],
        today: DateTime(2026, 3, 7),
      );
      expect(rate, equals(0.0));
    });

    test('7일 중 5일 완료 → 약 0.71', () {
      final checkins = List.generate(5, (i) => Checkin(
        id: 'c-$i',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, i + 1),
        streakDay: i,
      ));

      final rate = useCase.call(
        checkins: checkins,
        today: DateTime(2026, 3, 7),
      );

      expect(rate, closeTo(5 / 7, 0.01));
    });

    test('오늘까지 모두 완료 → 1.0', () {
      final checkins = List.generate(7, (i) => Checkin(
        id: 'c-$i',
        habitId: 'h-1',
        userId: 'uid-1',
        date: DateTime(2026, 3, i + 1),
        streakDay: i,
      ));

      final rate = useCase.call(
        checkins: checkins,
        today: DateTime(2026, 3, 7),
      );

      expect(rate, equals(1.0));
    });

    test('이번 달 체크인만 계산에 포함', () {
      final checkins = [
        Checkin(
          id: 'c-old',
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 2, 28), // 이전 달
          streakDay: 0,
        ),
        Checkin(
          id: 'c-1',
          habitId: 'h-1',
          userId: 'uid-1',
          date: DateTime(2026, 3, 1), // 이번 달
          streakDay: 1,
        ),
      ];

      final rate = useCase.call(
        checkins: checkins,
        today: DateTime(2026, 3, 7),
      );

      // 이번 달: 7일 중 1일 완료
      expect(rate, closeTo(1 / 7, 0.01));
    });
  });
}
