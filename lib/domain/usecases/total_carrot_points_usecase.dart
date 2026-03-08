import 'package:habit_rabbit/domain/entities/checkin.dart';

class TotalCarrotPointsUseCase {
  final List<Checkin> checkins;

  const TotalCarrotPointsUseCase({required this.checkins});

  int get total => checkins.fold(0, (sum, c) => sum + c.carrotPoints);
}
