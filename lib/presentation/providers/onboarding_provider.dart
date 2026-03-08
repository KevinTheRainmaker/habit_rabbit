import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingCompletedNotifierProvider =
    StateProvider<bool>((ref) => false);

final onboardingCompletedProvider = Provider<bool>(
  (ref) => ref.watch(onboardingCompletedNotifierProvider),
);
