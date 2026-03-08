import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_rabbit/data/repositories/hive_habit_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_mission_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_recovery_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_shop_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_subscription_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';
import 'package:habit_rabbit/presentation/providers/recovery_provider.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';
import 'package:habit_rabbit/presentation/providers/subscription_provider.dart';
import 'package:habit_rabbit/presentation/screens/habit_list_screen.dart';
import 'package:habit_rabbit/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final habitBox = await Hive.openBox('habits');
  final shopBox = await Hive.openBox('shop');
  final recoveryBox = await Hive.openBox('recovery');
  final missionBox = await Hive.openBox('missions');
  final subscriptionBox = await Hive.openBox('subscription');
  runApp(ProviderScope(
    overrides: [
      habitRepositoryProvider.overrideWithValue(HiveHabitRepository(habitBox)),
      shopRepositoryProvider.overrideWithValue(HiveShopRepository(shopBox)),
      recoveryRepositoryProvider.overrideWithValue(HiveRecoveryRepository(recoveryBox)),
      missionRepositoryProvider.overrideWithValue(HiveMissionRepository(missionBox)),
      subscriptionRepositoryProvider.overrideWithValue(HiveSubscriptionRepository(subscriptionBox)),
    ],
    child: const HabitRabbitApp(),
  ));
}

class HabitRabbitApp extends StatelessWidget {
  const HabitRabbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Rabbit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
        ),
        useMaterial3: true,
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) => user != null ? const HabitListScreen() : const LoginScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const LoginScreen(),
    );
  }
}
