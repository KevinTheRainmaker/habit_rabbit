import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/domain/entities/habit.dart';
import 'package:habit_rabbit/presentation/providers/auth_provider.dart';
import 'package:habit_rabbit/presentation/providers/carrot_points_provider.dart';
import 'package:habit_rabbit/presentation/providers/checkin_provider.dart';
import 'package:habit_rabbit/presentation/providers/habit_provider.dart';
import 'package:habit_rabbit/presentation/screens/add_habit_dialog.dart';

class HabitListScreen extends ConsumerWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final totalPoints = ref.watch(carrotPointsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 습관'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                '🥕 $totalPoints',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            data: (habits) {
              if (habits.isEmpty) {
                return const Center(child: Text('습관을 추가해보세요!'));
              }
              return ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  return _HabitTile(habit: habits[index], userId: user.id);
                },
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
                onPressed: () => _showAddHabitDialog(context, ref, user.id),
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context, WidgetRef ref, String userId) {
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

class _HabitTile extends ConsumerStatefulWidget {
  final Habit habit;
  final String userId;

  const _HabitTile({required this.habit, required this.userId});

  @override
  ConsumerState<_HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends ConsumerState<_HabitTile> {
  bool _checkedIn = false;
  int _earnedPoints = 0;

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
        subtitle: _checkedIn ? Text('🥕 +$_earnedPoints 획득!') : null,
        trailing: Icon(
          _checkedIn ? Icons.check_circle : Icons.check_circle_outline,
          color: _checkedIn ? Colors.orange : null,
        ),
        onTap: _onTap,
      ),
    );
  }
}
