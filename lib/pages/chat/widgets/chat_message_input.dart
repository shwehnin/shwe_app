import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/route_locations.dart';
import '../../../utils/extension.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../widgets/banned_container.dart';

class ChatMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const ChatMessageInput({
    super.key,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Global.isBanned,
      builder: (cts, isBanned, _) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: context.colors.primaryFixed,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile button
                GestureDetector(
                  onTap: () {
                    if (Global.user == null) {
                      context.pushNamed(RouteLocation.login);
                    } else {
                      context.pushNamed(RouteLocation.updateProfile);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  ),
                ),

                // Text input
                Expanded(
                  child: isBanned
                      ? const BannedContainerCard()
                      : ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100),
                          child: TextField(
                            maxLength: 180,
                            controller: controller,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            onSubmitted: (_) => onSend(),
                            maxLines: null,
                            minLines: 1,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              counter: Offstage(),
                              contentPadding: EdgeInsets.all(4),
                              hintText: "Message...",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                ),

                // Send button
                if (!isBanned) const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: isSending
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                              strokeWidth: 1.2,
                            ),
                          )
                        : IconButton(
                            onPressed: isBanned ? null : onSend,
                            icon: Image.asset(Imgs.send, width: 35, height: 35),
                          ),
                  ),
                ),

                const SizedBox(width: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
