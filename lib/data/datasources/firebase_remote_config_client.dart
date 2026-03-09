import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';
import 'remote_config_client.dart';

class FirebaseRemoteConfigClient implements RemoteConfigClient {
  final FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigClient({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  @override
  Future<CarrotPointConfig> fetchCarrotConfig() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // 네트워크 오류 시 캐시된 값 또는 기본값 사용
    }
    return CarrotPointConfig(
      basePoints: _remoteConfig.getInt('carrot_base_points'),
      sevenDayBonus: _remoteConfig.getInt('carrot_7day_bonus'),
      thirtyDayBonus: _remoteConfig.getInt('carrot_30day_bonus'),
      hundredDayBonus: _remoteConfig.getInt('carrot_100day_bonus'),
    );
  }
}
