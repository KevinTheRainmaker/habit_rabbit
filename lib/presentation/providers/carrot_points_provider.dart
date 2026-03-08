import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarrotPointsNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void add(int points) => state = state + points;
  void reset() => state = 0;
  void initialize(int total) => state = total;
}

final carrotPointsProvider = NotifierProvider<CarrotPointsNotifier, int>(
  CarrotPointsNotifier.new,
);
