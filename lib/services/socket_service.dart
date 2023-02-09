import 'package:chat_real_time/global/enviroment.dart';
import 'package:chat_real_time/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  Socket get socket => _socket;

 

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = io(
      Enviroment.socketUrl,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect() // disable auto-connection
          .enableForceNew()
          .setExtraHeaders({'x-token': token})
          .build(),
          
    );
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
  void disconnect(){
    _socket.disconnect();
  }
}
