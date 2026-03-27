import 'package:flutter/foundation.dart';
import '../data/models/config_model.dart';
import '../data/models/user_model.dart';
import 'ws_client.dart';

class Global {
  static bool offAds = false;
  static UserModel? user;
  static late ConfigModel config;
  static ValueNotifier<bool> notiStatus = ValueNotifier(true);
  static late AutoReconnectWebSocket webSocket;
  static ValueNotifier<String> liveSocket = ValueNotifier<String>(
    "Connecting...",
  );
  static ValueNotifier<bool> isBanned = ValueNotifier(false);
  static final ValueNotifier<bool> visible = ValueNotifier<bool>(true);
}
