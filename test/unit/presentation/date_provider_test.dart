import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/presentation/providers/date_provider.dart';

void main() {
  group('currentDateProvider', () {
    test('currentDateProvider는 DateTime을 반환한다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final date = container.read(currentDateProvider);
      expect(date, isA<DateTime>());
    });

    test('currentDateProvider override 시 지정한 날짜 반환', () {
      final fixedDate = DateTime(2026, 3, 10);
      final container = ProviderContainer(
        overrides: [
          currentDateProvider.overrideWith((ref) => fixedDate),
        ],
      );
      addTearDown(container.dispose);

      final date = container.read(currentDateProvider);
      expect(date, equals(fixedDate));
    });

    test('currentDateProvider는 StateProvider이므로 값 변경 가능', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final newDate = DateTime(2026, 3, 11);
      container.read(currentDateProvider.notifier).state = newDate;

      expect(container.read(currentDateProvider), equals(newDate));
    });
  });
}
