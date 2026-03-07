import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingCompletedProvider = Provider<bool>((ref) => false);

final onboardingCompletedNotifierProvider =
    StateProvider<bool>((ref) => false);
