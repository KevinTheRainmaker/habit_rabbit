import 'package:hive/hive.dart';

class HiveOnboardingRepository {
  final Box _box;

  static const _completedKey = 'onboarding_completed';

  HiveOnboardingRepository(this._box);

  Future<bool> isCompleted() async {
    return (_box.get(_completedKey) as bool?) ?? false;
  }

  Future<void> setCompleted() async {
    await _box.put(_completedKey, true);
  }

  Future<void> reset() async {
    await _box.delete(_completedKey);
  }
}
