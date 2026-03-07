import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final bool isPremium;

  const User({
    required this.id,
    required this.email,
    required this.isPremium,
  });

  @override
  List<Object> get props => [id];
}
