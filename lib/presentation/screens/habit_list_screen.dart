import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/checkin.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/domain/entities/user.dart';
import 'package:habit_rabbit/domain/usecases/monthly_completion_rate_usecase.dart';
import 'package:habit_rabbit/domain/usecases/today_habits_usecase.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/carrot_points_provider.dart';
import 'package:habit_rabbit/presentation/providers/checkin_provider.dart';
import 'package:habit_rabbit/presentation/providers/checkins_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/add_habit_dialog.dart';
import 'package:habit_rabbit/presentation/screens/edit_habit_dialog.dart';
import 'package:habit_rabbit/presentation/screens/habit_detail_screen.dart';
import 'package:habit_rabbit/presentation/providers/equipped_items_provider.dart';
import 'package:habit_rabbit/presentation/screens/notification_settings_screen.dart';
import 'package:habit_rabbit/presentation/screens/premium_gate_screen.dart';
import 'package:habit_rabbit/domain/usecases/streak_break_check_usecase.dart';
import 'package:habit_rabbit/domain/usecases/today_progress_usecase.dart';
import 'package:habit_rabbit/presentation/providers/recovery_provider.dart';
import 'package:habit_rabbit/presentation/screens/mission_screen.dart';
import 'package:habit_rabbit/presentation/screens/statistics_screen.dart';
import 'package:habit_rabbit/presentation/screens/shop_screen.dart';
import 'package:habit_rabbit/presentation/screens/streak_break_dialog.dart';
import 'package:habit_rabbit/presentation/widgets/completion_rate_card.dart';
import 'package:habit_rabbit/presentation/widgets/empty_habit_state.dart';
import 'package:habit_rabbit/presentation/widgets/habit_readiness_card.dart';
import 'package:habit_rabbit/domain/usecases/current_streak_usecase.dart';
import 'package:habit_rabbit/domain/usecases/streak_milestone_usecase.dart';
import 'package:habit_rabbit/domain/usecases/carrot_balance_usecase.dart';
import 'package:habit_rabbit/domain/usecases/mission_check_usecase.dart';
import 'package:habit_rabbit/presentation/providers/mission_provider.dart';
import 'package:habit_rabbit/presentation/providers/shop_provider.dart';
import 'package:habit_rabbit/presentation/providers/date_provider.dart';
import 'package:habit_rabbit/presentation/providers/subscription_provider.dart';

class HabitListScreen extends ConsumerStatefulWidget {
  const HabitListScreen({super.key});

  @override
  ConsumerState<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends ConsumerState<HabitListScreen>
    with WidgetsBindingObserver {
  int _upsellCount = 0;
  Timer? _midnightTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleMidnightRefresh();
  }

  void _scheduleMidnightRefresh() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final untilMidnight = tomorrow.difference(now);
    _midnightTimer = Timer(untilMidnight, () {
      if (mounted) {
        final current = ref.read(currentDateProvider);
        ref.read(currentDateProvider.notifier).state =
            DateTime(current.year, current.month, current.day + 1);
        _scheduleMidnightRefresh();
      }
    });
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(currentDateProvider.notifier).state = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final totalPoints = ref.watch(carrotPointsProvider);
    final equippedAsync = ref.watch(equippedItemsProvider);
    final equippedNames = equippedAsync.valueOrNull
        ?.map((i) => i.name)
        .join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('내 습관'),
            if (equippedNames != null && equippedNames.isNotEmpty)
              Text(
                equippedNames,
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ShopScreen()),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  '🥕 $totalPoints',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              final user = ref.read(currentUserProvider).valueOrNull;
              if (user == null) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StatisticsScreen(
                    userId: user.id,
                    isPremium: user.isPremium,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MissionScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              final currentUser = ref.read(currentUserProvider).valueOrNull;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NotificationSettingsScreen(
                    isPremium: currentUser?.isPremium ?? false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('습관을 추가해보세요!'));
          }
          final habitsAsync = ref.watch(habitListNotifierProvider(user.id));
          return habitsAsync.when(
            data: (allHabits) {
              final today = ref.watch(currentDateProvider);
              final habits = TodayHabitsUseCase().call(
                habits: allHabits,
                today: today,
              );
              if (allHabits.isEmpty) {
                return EmptyHabitState(
                  onAdd: () => _showAddHabitDialog(context, user),
                );
              }
              if (habits.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('😴', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 16),
                      Text(
                        '오늘은 쉬는 날이에요!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '내일 또 달려봐요 🐰',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return _HabitListBody(
                habits: habits,
                allHabits: allHabits,
                user: user,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('습관을 불러오지 못했어요'),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(habitListNotifierProvider(user.id)),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('오류가 발생했습니다')),
      ),
      floatingActionButton: userAsync.whenOrNull(
        data: (user) => user == null
            ? null
            : FloatingActionButton(
                onPressed: () => _showAddHabitDialog(context, user),
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, User user) {
    final userId = user.id;
    final isPremium = ref.read(isPremiumProvider).valueOrNull ?? user.isPremium;

    if (!isPremium) {
      final habits = ref.read(habitListNotifierProvider(userId)).valueOrNull ?? [];
      if (habits.length >= 3) {
        if (_upsellCount >= 3) return;
        setState(() => _upsellCount++);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const PremiumGateScreen(),
        );
        return;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddHabitDialog(
          onSaved: (name, days, icon) {
            ref
                .read(habitListNotifierProvider(userId).notifier)
                .addHabit(name: name, userId: userId, targetDays: days, icon: icon);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

class _HabitListBody extends ConsumerStatefulWidget {
  final List<Habit> habits;
  final List<Habit> allHabits;
  final User user;

  const _HabitListBody({
    required this.habits,
    required this.allHabits,
    required this.user,
  });

  @override
  ConsumerState<_HabitListBody> createState() => _HabitListBodyState();
}

class _HabitListBodyState extends ConsumerState<_HabitListBody> {
  bool _readinessDismissed = false;
  bool _streakBreakDismissed = false;
  bool _pointsInitialized = false;

  double _weeklyRate(List<Checkin> checkins, DateTime today) {
    int completed = 0;
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: i));
      if (checkins.any((c) =>
          c.date.year == day.year &&
          c.date.month == day.month &&
          c.date.day == day.day)) {
        completed++;
      }
    }
    return completed / 7;
  }

  @override
  Widget build(BuildContext context) {
    final allCheckins = widget.allHabits.expand((habit) {
      final asyncCheckins = ref.watch(
        checkinsListProvider((habitId: habit.id, userId: widget.user.id)),
      );
      return asyncCheckins.valueOrNull ?? const <Checkin>[];
    }).cast<Checkin>().toList();

    if (!_pointsInitialized && allCheckins.isNotEmpty) {
      _pointsInitialized = true;
      final ownedItems = ref.read(shopRepositoryProvider).getOwnedItems();
      ownedItems.then((items) {
        final balance = CarrotBalanceUseCase(
          checkins: allCheckins,
          ownedItems: items,
        ).balance;
        ref.read(carrotPointsProvider.notifier).initialize(balance);
      });
    }

    final today = ref.watch(currentDateProvider);
    final rate = _weeklyRate(allCheckins, today);
    final showReadiness =
        !_readinessDismissed && rate >= 0.8 && widget.allHabits.length < 3;

    final isStreakBroken = !_streakBreakDismissed &&
        StreakBreakCheckUseCase(
          checkins: allCheckins.map((c) => c.date).toList(),
          today: today,
        ).isStreakBroken;

    final ticketAsync = ref.watch(
      recoveryTicketProvider(widget.user.id),
    );
    final freeTrialUsed =
        ticketAsync.valueOrNull?.freeTrialUsed ?? false;

    final progress = TodayProgressUseCase(
      habits: widget.allHabits,
      checkins: allCheckins,
      today: today,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '오늘 ${progress.completed} / ${progress.total}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        CompletionRateCard(
          rate: MonthlyCompletionRateUseCase()(
            checkins: allCheckins,
            today: today,
          ),
          currentStreak: CurrentStreakUseCase(
            checkins: allCheckins.map((c) => c.date).toList(),
            today: today,
          ).currentStreak,
        ),
        if (showReadiness)
          HabitReadinessCard(
            weeklyCompletionRate: rate,
            onAdd: () {
              final userId = widget.user.id;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: AddHabitDialog(
                    onSaved: (name, days, icon) {
                      ref
                          .read(habitListNotifierProvider(userId).notifier)
                          .addHabit(name: name, userId: userId, targetDays: days, icon: icon);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
              setState(() => _readinessDismissed = true);
            },
            onDismiss: () => setState(() => _readinessDismissed = true),
          ),
        if (isStreakBroken)
          StreakBreakDialog(
            freeTrialUsed: freeTrialUsed,
            onUseFreeRecovery: () {
              ref
                  .read(recoveryRepositoryProvider)
                  .useFreeTrial(userId: widget.user.id);
              setState(() => _streakBreakDismissed = true);
            },
            onRestart: () => setState(() => _streakBreakDismissed = true),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(habitListNotifierProvider(widget.user.id));
            },
            child: ListView.builder(
              itemCount: widget.habits.length,
              itemBuilder: (context, index) {
                return _HabitTile(
                    habit: widget.habits[index], user: widget.user);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _HabitTile extends ConsumerStatefulWidget {
  final Habit habit;
  final User user;

  String get userId => user.id;

  const _HabitTile({required this.habit, required this.user});

  @override
  ConsumerState<_HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends ConsumerState<_HabitTile> {
  bool _sessionCheckedIn = false;
  int _earnedPoints = 0;
  int _streak = 0;
  String? _milestoneMessage;

  Future<void> _autoCompleteMissions(int newStreakDay) async {
    final repo = ref.read(missionRepositoryProvider);
    final missions = await repo.getMissions();
    final completedIds = missions.where((m) => m.isCompleted).map((m) => m.id).toSet();

    // newStreakDay is the streak after the new checkin (1-indexed)
    final pending = MissionCheckUseCase(
      totalCheckins: newStreakDay,
      habitCount: 1,
      bestStreak: newStreakDay,
    ).completableMissionIds;

    for (final id in pending) {
      if (!completedIds.contains(id)) {
        try {
          await repo.completeMission(missionId: id);
          ref.invalidate(missionsProvider);
        } catch (_) {}
      }
    }
  }

  Future<void> _onTap() async {
    if (_sessionCheckedIn) return;
    final today = ref.read(currentDateProvider);
    final checkinsAsync = ref.read(
      checkinsListProvider((habitId: widget.habit.id, userId: widget.userId)),
    );
    final alreadyCheckedIn = checkinsAsync.valueOrNull?.any(
          (c) =>
              c.date.year == today.year &&
              c.date.month == today.month &&
              c.date.day == today.day,
        ) ??
        false;
    if (alreadyCheckedIn) return;
    try {
      final checkin = await ref.read(
        checkInProvider((
          habitId: widget.habit.id,
          userId: widget.userId,
          date: DateTime.now(),
        )).future,
      );
      ref.read(carrotPointsProvider.notifier).add(checkin.carrotPoints);
      final streak = checkin.streakDay + 1;
      setState(() {
        _sessionCheckedIn = true;
        _earnedPoints = checkin.carrotPoints;
        _streak = streak;
        _milestoneMessage = StreakMilestoneUseCase(streak: streak).message;
      });
      _autoCompleteMissions(checkin.streakDay + 1);
      HapticFeedback.mediumImpact().ignore();
    } catch (_) {
      // 이미 체크인한 경우 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkinsAsync = ref.watch(
      checkinsListProvider((habitId: widget.habit.id, userId: widget.userId)),
    );
    final today = ref.watch(currentDateProvider);
    final alreadyCheckedIn = checkinsAsync.valueOrNull?.any(
          (c) =>
              c.date.year == today.year &&
              c.date.month == today.month &&
              c.date.day == today.day,
        ) ??
        false;
    final checkedIn = _sessionCheckedIn || alreadyCheckedIn;

    return Dismissible(
      key: Key(widget.habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            content: const Text('삭제하면 기록도 사라져요'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('삭제'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => ref
          .read(habitListNotifierProvider(widget.userId).notifier)
          .deleteHabit(habitId: widget.habit.id, userId: widget.userId),
      child: ListTile(
        leading: widget.habit.icon.isNotEmpty ? Text(widget.habit.icon, style: const TextStyle(fontSize: 24)) : null,
        title: Text(widget.habit.name),
        subtitle: checkedIn
            ? Text(_milestoneMessage != null
                ? '🥕 +$_earnedPoints 획득! · 🔥 $_streak일 연속\n$_milestoneMessage'
                : '🥕 +$_earnedPoints 획득! · 🔥 $_streak일 연속')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              checkedIn ? Icons.check_circle : Icons.check_circle_outline,
              color: checkedIn ? Colors.orange : null,
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HabitDetailScreen(
                      habit: widget.habit,
                      user: widget.user,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        onTap: _onTap,
        onLongPress: _onLongPress,
      ),
    );
  }

  void _onLongPress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditHabitDialog(
          habit: widget.habit,
          onSaved: (name, days, icon) {
            ref
                .read(habitListNotifierProvider(widget.userId).notifier)
                .updateHabit(widget.habit.copyWith(name: name, targetDays: days, icon: icon));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

