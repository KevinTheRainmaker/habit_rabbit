import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

final checkInProvider = FutureProvider.family<Checkin, ({String habitId, String userId, DateTime date})>(
  (ref, args) async {
    final repository = ref.watch(habitRepositoryProvider);
    return repository.checkIn(
      habitId: args.habitId,
      userId: args.userId,
      date: args.date,
    );
  },
);
