import 'package:equatable/equatable.dart';

class RecoveryTicket extends Equatable {
  final int count;
  final bool freeTrialUsed;

  const RecoveryTicket({
    required this.count,
    required this.freeTrialUsed,
  });

  bool get canUse => count > 0;
  bool get canUseFreeTrial => !freeTrialUsed;

  RecoveryTicket copyWith({int? count, bool? freeTrialUsed}) => RecoveryTicket(
        count: count ?? this.count,
        freeTrialUsed: freeTrialUsed ?? this.freeTrialUsed,
      );

  @override
  List<Object> get props => [count, freeTrialUsed];
}
