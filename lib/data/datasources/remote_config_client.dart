import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

abstract class RemoteConfigClient {
  Future<CarrotPointConfig> fetchCarrotConfig();
}
