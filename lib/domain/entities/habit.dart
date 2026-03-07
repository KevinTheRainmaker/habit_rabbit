import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final bool isActive;

  const Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.isActive,
  });

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? createdAt,
    bool? isActive,
  }) => Habit(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );

  @override
  List<Object> get props => [id];
}
