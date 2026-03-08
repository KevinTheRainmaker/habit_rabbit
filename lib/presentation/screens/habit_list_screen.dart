import 'package:flutter/material.dart';
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
import 'package:habit_rabbit/presentation/providers/recovery_provider.dart';
import 'package:habit_rabbit/presentation/screens/mission_screen.dart';
import 'package:habit_rabbit/presentation/screens/statistics_screen.dart';
import 'package:habit_rabbit/presentation/screens/shop_screen.dart';
import 'package:habit_rabbit/presentation/screens/streak_break_dialog.dart';
import 'package:habit_rabbit/presentation/widgets/completion_rate_card.dart';
import 'package:habit_rabbit/presentation/widgets/habit_readiness_card.dart';

class HabitListScreen extends ConsumerWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  builder: (_) => StatisticsScreen(userId: user.id),
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NotificationSettingsScreen(),
              ),
            ),
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
              final habits = TodayHabitsUseCase().call(
                habits: allHabits,
                today: DateTime.now(),
              );
              if (habits.isEmpty) {
                return const Center(child: Text('습관을 추가해보세요!'));
              }
              return _HabitListBody(
                habits: habits,
                allHabits: allHabits,
                user: user,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('오류가 발생했습니다')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('오류가 발생했습니다')),
      ),
      floatingActionButton: userAsync.whenOrNull(
        data: (user) => user == null
            ? null
            : FloatingActionButton(
                onPressed: () => _showAddHabitDialog(context, ref, user),
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref, User user) {
    final userId = user.id;
    final isPremium = user.isPremium;

    if (!isPremium) {
      final habits = ref.read(habitListNotifierProvider(userId)).valueOrNull ?? [];
      if (habits.length >= 3) {
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
          onSaved: (name) {
            ref
                .read(habitListNotifierProvider(userId).notifier)
                .addHabit(name: name, userId: userId);
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

  double _weeklyRate(List<Checkin> checkins) {
    final today = DateTime.now();
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

    final today = DateTime.now();
    final rate = _weeklyRate(allCheckins);
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

    return Column(
      children: [
        CompletionRateCard(
          rate: MonthlyCompletionRateUseCase()(
            checkins: allCheckins,
            today: today,
          ),
        ),
        if (showReadiness)
          HabitReadinessCard(
            weeklyCompletionRate: rate,
            onAdd: () {},
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
          child: ListView.builder(
            itemCount: widget.habits.length,
            itemBuilder: (context, index) {
              return _HabitTile(
                  habit: widget.habits[index], user: widget.user);
            },
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
  bool _checkedIn = false;
  int _earnedPoints = 0;
  int _streak = 0;

  Future<void> _onTap() async {
    if (_checkedIn) return;
    try {
      final checkin = await ref.read(
        checkInProvider((
          habitId: widget.habit.id,
          userId: widget.userId,
          date: DateTime.now(),
        )).future,
      );
      ref.read(carrotPointsProvider.notifier).add(checkin.carrotPoints);
      setState(() {
        _checkedIn = true;
        _earnedPoints = checkin.carrotPoints;
        _streak = checkin.streakDay + 1;
      });
    } catch (_) {
      // 이미 체크인한 경우 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => ref
          .read(habitListNotifierProvider(widget.userId).notifier)
          .deleteHabit(habitId: widget.habit.id, userId: widget.userId),
      child: ListTile(
        title: Text(widget.habit.name),
        subtitle: _checkedIn
            ? Text('🥕 +$_earnedPoints 획득! · 🔥 $_streak일 연속')
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _checkedIn ? Icons.check_circle : Icons.check_circle_outline,
              color: _checkedIn ? Colors.orange : null,
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
          onSaved: (name) {
            ref
                .read(habitListNotifierProvider(widget.userId).notifier)
                .updateHabit(widget.habit.copyWith(name: name));
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

