import 'package:flutter_test/flutter_test.dart';
import 'package:habit_rabbit/domain/entities/user.dart';

void main() {
  group('User entity', () {
    test('두 User가 같은 id를 가지면 동일하다', () {
      const user1 = User(id: 'uid-1', email: 'test@test.com', isPremium: false);
      const user2 = User(id: 'uid-1', email: 'other@test.com', isPremium: true);

      expect(user1, equals(user2));
    });

    test('isPremium false인 User는 프리미엄 기능 없음', () {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: false);

      expect(user.isPremium, isFalse);
    });

    test('isPremium true인 User는 프리미엄 기능 있음', () {
      const user = User(id: 'uid-1', email: 'test@test.com', isPremium: true);

      expect(user.isPremium, isTrue);
    });
  });
}
