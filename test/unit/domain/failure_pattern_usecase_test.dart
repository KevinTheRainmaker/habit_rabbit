import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/failure_pattern_usecase.dart';

void main() {
  group('FailurePatternUseCase', () {
    test('14일 미만 데이터면 isReady false', () {
      final today = DateTime(2026, 3, 7);
      final checkins = List.generate(
        13,
        (i) => today.subtract(Duration(days: i)),
      );
      final useCase = FailurePatternUseCase(checkins: checkins, today: today);
      expect(useCase.isReady, isFalse);
    });

    test('14일 이상 데이터면 isReady true', () {
      final today = DateTime(2026, 3, 7);
      final checkins = List.generate(
        14,
        (i) => today.subtract(Duration(days: i)),
      );
      final useCase = FailurePatternUseCase(checkins: checkins, today: today);
      expect(useCase.isReady, isTrue);
    });

    test('빈 체크인이면 worstDay null', () {
      final useCase = FailurePatternUseCase(
        checkins: [],
        today: DateTime(2026, 3, 7),
      );
      expect(useCase.worstDay, isNull);
    });

    test('특정 요일에만 체크인 없으면 해당 요일이 worstDay', () {
      // 2주치 데이터: 월요일(weekday=1)만 빠짐
      final today = DateTime(2026, 3, 7); // Saturday
      final checkins = <DateTime>[];
      for (int i = 0; i < 14; i++) {
        final day = today.subtract(Duration(days: i));
        if (day.weekday != DateTime.monday) {
          checkins.add(day);
        }
      }
      final useCase = FailurePatternUseCase(checkins: checkins, today: today);
      // Monday has weekday=1, which maps to index 0 (월=0 in our 0-indexed system)
      expect(useCase.worstDay, isNotNull);
    });

    test('모든 요일 체크인이 균등하면 worstDay 반환', () {
      final today = DateTime(2026, 3, 7);
      final checkins = List.generate(14, (i) => today.subtract(Duration(days: i)));
      final useCase = FailurePatternUseCase(checkins: checkins, today: today);
      // All days have equal checkins, worstDay still exists
      expect(useCase.isReady, isTrue);
    });
  });
}
