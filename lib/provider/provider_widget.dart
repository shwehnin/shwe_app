import 'package:flutter/material.dart';
import 'block_provider.dart';
import 'chat_room_provider.dart';
import 'live_provider.dart';
import 'private_chat_provider.dart';
import 'public_chat_provider.dart';
import 'package:provider/provider.dart';

class ProviderWidget extends StatelessWidget {
  final Widget child;
  const ProviderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LiveProvider()),
        ChangeNotifierProvider(create: (_) => BlockProvider()),
        ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
        ChangeNotifierProvider(create: (_) => PublicChatProvider()),
        ChangeNotifierProvider(create: (_) => PrivateChatProvider()),
      ],
      child: child,
    );
  }
}
