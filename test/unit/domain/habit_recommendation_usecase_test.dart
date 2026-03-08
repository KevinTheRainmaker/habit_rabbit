import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/usecases/habit_recommendation_usecase.dart';

void main() {
  group('HabitRecommendationUseCase', () {
    test('아침 루틴 선택 시 아침 관련 습관 포함', () {
      final useCase = HabitRecommendationUseCase(
        answers: ['건강한 몸 만들기', '아침 (기상 후)', '처음이에요'],
      );
      final recs = useCase.recommendations;
      expect(recs, isNotEmpty);
      expect(recs.any((r) => r.contains('스트레칭') || r.contains('물') || r.contains('운동')), isTrue);
    });

    test('저녁 루틴 선택 시 저녁 관련 습관 포함', () {
      final useCase = HabitRecommendationUseCase(
        answers: ['마음의 여유 찾기', '취침 전', '처음이에요'],
      );
      final recs = useCase.recommendations;
      expect(recs, isNotEmpty);
      expect(recs.any((r) => r.contains('독서') || r.contains('일기') || r.contains('명상')), isTrue);
    });

    test('생산성 목표 선택 시 관련 습관 포함', () {
      final useCase = HabitRecommendationUseCase(
        answers: ['생산성 높이기', '점심 (식사 전후)', '처음이에요'],
      );
      final recs = useCase.recommendations;
      expect(recs, isNotEmpty);
    });

    test('추천 목록은 최소 2개 이상', () {
      final useCase = HabitRecommendationUseCase(answers: []);
      expect(useCase.recommendations.length, greaterThanOrEqualTo(2));
    });
  });
}
