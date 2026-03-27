import 'package:flutter/material.dart';
import 'package:new_lion/utils/app_colors.dart';
import '../../../utils/images.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../widgets/network_imge_view.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isSender;
  final VoidCallback? onTap;

  const MessageBubble({
    super.key,
    required this.isSender,
    required this.msg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final message = msg.content ?? "";
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: isSender ? 4 : 8,
        ),
        child: Row(
          mainAxisAlignment: isSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSender) ...[_buildAvatar(), const SizedBox(width: 8)],
            Flexible(
              child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isSender) _buildSenderName(context),
                  _buildMessageContainer(context, message, isDark),
                  const SizedBox(height: 2),
                  _buildTimestamp(context, isDark),
                ],
              ),
            ),
            if (isSender) ...[
              // const SizedBox(width: 8),
              // _buildSenderAvatar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: NetworkImageView(
        url: msg.sender?.cover,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        fallbackAssets: Imgs.user,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildSenderName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Text(
        msg.sender?.name ?? 'Unknown',
        style: TextStyle(
          // color: context.colors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildMessageContainer(
    BuildContext context,
    String message,
    bool isDark,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
        minWidth: 60,
      ),
      decoration: BoxDecoration(
        gradient: isSender
            ? LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : isDark
            ? null
            : LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 1),
                  AppColors.primary.withValues(alpha: .5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDark ? Colors.grey.shade800 : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isSender ? 20 : 8),
          topRight: Radius.circular(isSender ? 8 : 20),
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: isSender
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 20 : 8),
            topRight: Radius.circular(isSender ? 8 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context, bool isDark) {
    final timeAgo = _getTimeAgo();

    return Padding(
      padding: EdgeInsets.only(
        left: isSender ? 0 : 4,
        right: isSender ? 4 : 0,
        top: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeAgo,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 4),
            Icon(Icons.done_all, size: 14, color: Colors.blue.shade400),
          ],
        ],
      ),
    );
  }

  String _getTimeAgo() {
    if (msg.createdAt == null) return 'Now';

    final now = DateTime.now();
    final messageTime = DateTime.parse(msg.createdAt!);
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }
}
