import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastSyncedAtNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void update(DateTime time) => state = time;
}

final lastSyncedAtProvider =
    NotifierProvider<LastSyncedAtNotifier, DateTime?>(LastSyncedAtNotifier.new);
