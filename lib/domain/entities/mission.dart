import 'package:equatable/equatable.dart';

class Mission extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String rewardItemId;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.rewardItemId,
  });

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? rewardItemId,
  }) =>
      Mission(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        rewardItemId: rewardItemId ?? this.rewardItemId,
      );

  @override
  List<Object> get props => [id];
}
