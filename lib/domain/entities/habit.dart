import 'package:equatable/equatable.dart';

const _allDays = [0, 1, 2, 3, 4, 5, 6];

class Habit extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final bool isActive;
  final List<int> targetDays;

  const Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.isActive,
    this.targetDays = _allDays,
  });

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
    bool? isActive,
    List<int>? targetDays,
  }) => Habit(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
    targetDays: targetDays ?? this.targetDays,
  );

  @override
  List<Object> get props => [id];
}
