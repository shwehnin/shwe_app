
// Auto Reconnect WebSocket Class
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class AutoReconnectWebSocket {
  final String url;
  final Duration reconnectInterval;
  final int? maxRetries;
  final Function(String)? onStatusChange;
  
  WebSocketChannel? _channel;
  StreamController<dynamic>? _messageController;
  Timer? _reconnectTimer;
  int _retryCount = 0;
  bool _isManualClose = false;
  
  Stream<dynamic> get stream => _messageController!.stream;
  
  AutoReconnectWebSocket({
    required this.url,
    this.reconnectInterval = const Duration(seconds: 5),
    this.maxRetries,
    this.onStatusChange,
  }) {
    _messageController = StreamController.broadcast();
  }

  Future<void> connect() async {
    try {
      _isManualClose = false;
      _updateStatus('Connecting...');
      
      _channel = WebSocketChannel.connect(Uri.parse(url));
      await _channel!.ready;
      
      _updateStatus('Connected');
      _retryCount = 0;
      
      _channel!.stream.listen(
        (message) {
          _messageController!.add(message);
        },
        onError: (error) {
          _updateStatus('Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          _updateStatus('Disconnected');
          _handleDisconnect();
        },
      );
      
    } catch (e) {
      _updateStatus('Failed: $e');
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    if (_isManualClose) return;
    
    if (maxRetries != null && _retryCount >= maxRetries!) {
      _updateStatus('Max retries reached');
      return;
    }
    
    _retryCount++;
    _updateStatus('Reconnecting... ($_retryCount)');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectInterval, () {
      connect();
    });
  }

  void _updateStatus(String status) {
    onStatusChange?.call(status);
  }

  void send(dynamic message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void close() {
    _isManualClose = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _updateStatus('Disconnected');
  }

  void dispose() {
    close();
    _messageController?.close();
  }
}