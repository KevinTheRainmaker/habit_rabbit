import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';

final checkinsListProvider = FutureProvider.family<
    List<Checkin>, ({String habitId, String userId})>(
  (ref, args) async {
    final repository = ref.watch(habitRepositoryProvider);
    return repository.getCheckins(
      habitId: args.habitId,
      userId: args.userId,
    );
  },
);
