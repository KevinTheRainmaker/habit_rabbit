import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_rabbit/data/datasources/firebase_remote_config_client.dart';
import 'package:habit_rabbit/data/datasources/remote_config_client.dart';
import 'package:habit_rabbit/domain/models/carrot_point_config.dart';

final remoteConfigClientProvider = Provider<RemoteConfigClient>((ref) {
  return FirebaseRemoteConfigClient();
});

final carrotConfigProvider = FutureProvider<CarrotPointConfig>((ref) async {
  final client = ref.watch(remoteConfigClientProvider);
  return client.fetchCarrotConfig();
});
