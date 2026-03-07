import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/mission.dart';

void main() {
  group('Mission', () {
    test('기본 미션 엔티티', () {
      const mission = Mission(
        id: 'm-1',
        title: '첫 습관 완료',
        description: '처음으로 습관을 완료하세요',
        isCompleted: false,
        rewardItemId: 'item-1',
      );
      expect(mission.id, equals('m-1'));
      expect(mission.title, equals('첫 습관 완료'));
      expect(mission.isCompleted, isFalse);
    });

    test('달성 여부 확인', () {
      const mission = Mission(
        id: 'm-1',
        title: '첫 습관 완료',
        description: '처음으로 습관을 완료하세요',
        isCompleted: true,
        rewardItemId: 'item-1',
      );
      expect(mission.isCompleted, isTrue);
    });

    test('copyWith으로 완료 처리', () {
      const mission = Mission(
        id: 'm-1',
        title: '첫 습관 완료',
        description: '처음으로 습관을 완료하세요',
        isCompleted: false,
        rewardItemId: 'item-1',
      );
      final completed = mission.copyWith(isCompleted: true);
      expect(completed.isCompleted, isTrue);
      expect(completed.id, equals('m-1'));
    });

    test('같은 id는 동일하다', () {
      const a = Mission(
        id: 'm-1',
        title: '첫 습관 완료',
        description: '처음으로 습관을 완료하세요',
        isCompleted: false,
        rewardItemId: 'item-1',
      );
      const b = Mission(
        id: 'm-1',
        title: '첫 습관 완료',
        description: '처음으로 습관을 완료하세요',
        isCompleted: true,
        rewardItemId: 'item-1',
      );
      expect(a, equals(b));
    });
  });
}
