import 'package:equatable/equatable.dart';

class CarrotPointConfig extends Equatable {
  final int basePoints;
  final int sevenDayBonus;
  final int thirtyDayBonus;
  final int hundredDayBonus;

  static const defaults = CarrotPointConfig();

  const CarrotPointConfig({
    this.basePoints = 10,
    this.sevenDayBonus = 5,
    this.thirtyDayBonus = 10,
    this.hundredDayBonus = 15,
  });

  int computePoints(int streakDay) {
    int points = basePoints;
    if (streakDay == 99) {
      points += hundredDayBonus;
    } else if (streakDay == 29) {
      points += thirtyDayBonus;
    } else if (streakDay == 6) {
      points += sevenDayBonus;
    }
    return points;
  }

  @override
  List<Object> get props => [basePoints, sevenDayBonus, thirtyDayBonus, hundredDayBonus];
}
