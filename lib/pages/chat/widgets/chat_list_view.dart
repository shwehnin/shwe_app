import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/route_locations.dart';
import '../../../data/models/chat_message_model.dart';
import 'message_bubble.dart';
import '../../../utils/global.dart';
import 'scroll_to_bottom_button.dart';

class ChatListView extends StatefulWidget {
  final List<ChatMessageModel> messages;
  final ScrollController scrollController;

  const ChatListView({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!widget.scrollController.hasClients) return;
    final shouldShow = widget.scrollController.position.pixels > 200;
    if (shouldShow != _showScrollButton) {
      setState(() => _showScrollButton = shouldShow);
    }
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          reverse: true,
          controller: widget.scrollController,
          itemCount: widget.messages.length,
          itemBuilder: (ctx, idx) {
            final msg = widget.messages[idx];
            final isSender = msg.sender!.id == Global.user?.id;
            return MessageBubble(
              msg: msg,
              isSender: isSender,
              onTap: () {
                if (isSender) return;
                FocusScope.of(context).unfocus();
                if (Global.user == null) {
                  context.pushNamed(RouteLocation.login);
                  return;
                }
                context.pushNamed(RouteLocation.userDetail, extra: msg);
              },
            );
          },
        ),
        if (_showScrollButton) ScrollToBottomButton(onTap: _scrollToBottom),
      ],
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
