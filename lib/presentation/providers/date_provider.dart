import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
