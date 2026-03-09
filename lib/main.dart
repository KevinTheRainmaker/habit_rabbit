import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_rabbit/data/repositories/firebase_auth_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_habit_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_mission_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_notification_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_onboarding_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_recovery_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_shop_repository.dart';
import 'package:habit_rabbit/data/repositories/hive_subscription_repository.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';
import 'package:habit_rabbit/presentation/providers/notification_provider.dart';
import 'package:habit_rabbit/presentation/providers/onboarding_provider.dart';
import 'package:habit_rabbit/presentation/providers/recovery_provider.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';
import 'package:habit_rabbit/presentation/providers/subscription_provider.dart';
import 'package:habit_rabbit/presentation/screens/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  final habitBox = await Hive.openBox('habits');
  final shopBox = await Hive.openBox('shop');
  final recoveryBox = await Hive.openBox('recovery');
  final missionBox = await Hive.openBox('missions');
  final subscriptionBox = await Hive.openBox('subscription');
  final notifBox = await Hive.openBox('notification');
  final onboardingBox = await Hive.openBox('onboarding');
  final notifRepo = HiveNotificationRepository(notifBox);
  final onboardingRepo = HiveOnboardingRepository(onboardingBox);
  final initialNotifSettings = await notifRepo.loadSettings();
  final initialOnboardingCompleted = await onboardingRepo.isCompleted();
  runApp(ProviderScope(
    overrides: [
      habitRepositoryProvider.overrideWithValue(HiveHabitRepository(habitBox)),
      shopRepositoryProvider.overrideWithValue(HiveShopRepository(shopBox)),
      recoveryRepositoryProvider.overrideWithValue(HiveRecoveryRepository(recoveryBox)),
      missionRepositoryProvider.overrideWithValue(HiveMissionRepository(missionBox)),
      subscriptionRepositoryProvider.overrideWithValue(HiveSubscriptionRepository(subscriptionBox)),
      authRepositoryProvider.overrideWithValue(FirebaseAuthRepository()),
      notificationSettingsProvider.overrideWith((ref) => initialNotifSettings),
      onboardingCompletedNotifierProvider.overrideWith(
        (ref) => initialOnboardingCompleted,
      ),
    ],
    child: HabitRabbitApp(notifRepo: notifRepo, onboardingRepo: onboardingRepo),
  ));
}

class HabitRabbitApp extends ConsumerWidget {
  final HiveNotificationRepository? notifRepo;
  final HiveOnboardingRepository? onboardingRepo;

  const HabitRabbitApp({this.notifRepo, this.onboardingRepo, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notifRepo != null) {
      ref.listen(notificationSettingsProvider, (_, next) {
        notifRepo!.saveSettings(next);
      });
    }
    if (onboardingRepo != null) {
      ref.listen(onboardingCompletedNotifierProvider, (_, next) {
        if (next) {
          onboardingRepo!.setCompleted();
        } else {
          onboardingRepo!.reset();
        }
      });
    }
    return MaterialApp(
      title: 'Habit Rabbit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
        ),
        useMaterial3: true,
      ),
      home: const AppRouter(),
    );
  }
}
