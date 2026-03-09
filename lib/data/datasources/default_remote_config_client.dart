import 'package:habit_rabbit/domain/models/carrot_point_config.dart';
import 'remote_config_client.dart';

class DefaultRemoteConfigClient implements RemoteConfigClient {
  @override
  Future<CarrotPointConfig> fetchCarrotConfig() async {
    return CarrotPointConfig.defaults;
  }
}
