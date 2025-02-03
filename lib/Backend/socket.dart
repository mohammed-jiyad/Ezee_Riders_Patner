import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io(
      'http://145.223.23.193:3000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // Specify transport
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  IO.Socket getSocket() {
    return socket;
  }
}
