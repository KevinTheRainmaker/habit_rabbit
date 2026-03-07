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

  @override
  List<Object> get props => [id];
}
