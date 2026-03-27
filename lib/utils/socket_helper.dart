import 'package:flutter/foundation.dart';
import 'package:new_lion/utils/const.dart';
import 'global.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketCommand {
  static String get init => "init";
  static String get joinRoom => "join_room";

  static String get stopTyping => "stop_typing";
  static String get startTyping => "start_typing";

  static String get publicNewMessage => "new_public_message";
  static String get privateNewMessage => "new_private_message";
  static String get live => "live";
  static String get ban => "ban";
}

class SocketHelper {
  SocketHelper._();
  static late Socket socket;
  static const String _socketURL = "${Const.workerURL}/socket";

  static final List<String> _listeningEvent = [];

  static clearEvent() => _listeningEvent.clear();

  static Future<void> initialize() async {
    var query = {};

    var user = Global.user?.id;
    if (user != null) {
      query = {"user_id": user};
    }

    socket = io(
      _socketURL,
      OptionBuilder().setTransports(['websocket']).setQuery(query).build(),
    );

    socket.onConnect((_) async {
      if (Global.user?.id != null) {
        emit(cmd: SocketCommand.init, data: Global.user?.id);
      }
    });
    socket.onConnectError((d) => debugPrint('error $d'));
    socket.onDisconnect((_) => debugPrint('disconnected'));
  }

  static void emit({required String cmd, dynamic data}) {
    socket.emit(cmd, data);
  }

  static void listen({
    required String cmd,
    required Function(dynamic) callback,
  }) {
    //check already listen or not
    if (_listeningEvent.contains(cmd)) {
      //  already listening
    } else {
      _listeningEvent.add(cmd);
      socket.on(cmd, callback);
    }
  }

  static disconnect() => socket.disconnect();

  static off({required String cmd}) {
    if (_listeningEvent.contains(cmd)) {
      _listeningEvent.remove(cmd);
      socket.off(cmd);
    }
  }
}
