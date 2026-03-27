import 'package:flutter/material.dart';
import '../../provider/block_provider.dart';
import 'package:provider/provider.dart';
import '../../data/api/user_api.dart';
import '../../utils/extension.dart';
import '../../utils/images.dart';
import '../../utils/reusable.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';
import '../../widgets/network_imge_view.dart';
import '../../data/models/chat_message_model.dart';

class UserDetail extends StatefulWidget {
  final ChatMessageModel message;
  const UserDetail({super.key, required this.message});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late BlockProvider _blockProvider;

  @override
  void initState() {
    super.initState();
    _blockProvider = context.read<BlockProvider>();
  }

  bool get _isBlocked => _blockProvider.exist(widget.message.sender!.id!);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final sender = widget.message.sender;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111111) : Colors.white,
      appBar: AppBar(
        
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _NavBtn(
              icon: Icons.more_vert_rounded,
              onTap: _report,
              isDark: isDark,
            ),
          ),
        ],
      ),
      body: Consumer<BlockProvider>(
        builder: (_, __, ___) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                // ── Profile card ──
                _ProfileCard(
                  sender: sender,
                  isBlocked: _isBlocked,
                  isDark: isDark,
                  onTapAvatar: _viewCover,
                ),
                const SizedBox(height: 12),

                // ── Action group ──
                _ActionGroup(
                  isDark: isDark,
                  children: [
                    _ActionTile(
                      icon: Icons.flag_outlined,
                      iconColor: isDark
                          ? Colors.white54
                          : const Color(0xFF666666),
                      iconBg: isDark
                          ? const Color(0xFF222222)
                          : const Color(0xFFF5F5F5),
                      label: 'Report user',
                      isDark: isDark,
                      onTap: _report,
                    ),
                    _ActionDivider(isDark: isDark),
                    _ActionTile(
                      icon: _isBlocked
                          ? Icons.lock_open_rounded
                          : Icons.block_rounded,
                      iconColor: _isBlocked
                          ? const Color(0xFFC07800)
                          : const Color(0xFFE05555),
                      iconBg: _isBlocked
                          ? (isDark
                              ? const Color(0xFF2A2010)
                              : const Color(0xFFFFFBF0))
                          : (isDark
                              ? const Color(0xFF2A1818)
                              : const Color(0xFFFFF2F2)),
                      label: _isBlocked ? 'Unblock user' : 'Block user',
                      labelColor: _isBlocked
                          ? const Color(0xFFC07800)
                          : const Color(0xFFE05555),
                      isDark: isDark,
                      onTap: _toggleBlock,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleBlock() async {
    final sender = widget.message.sender!;
    final action = _isBlocked ? 'Unblock' : 'Block';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: Text('$action User',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500)),
        content: Text('$action ${sender.name ?? "this user"}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: TextStyle(
                    color: context.isDarkMode
                        ? Colors.white54
                        : Colors.black45)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(action,
                style:
                    const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    EasyOverlay.show();
    final response = _isBlocked
        ? await UserApi.removeFromBlockList(user: sender)
        : await UserApi.addToBlockList(user: sender);
    EasyOverlay.dismiss();

    if (response.status && mounted) {
      _isBlocked
          ? _blockProvider.remove(sender)
          : _blockProvider.add(sender);
      EasyOverlay.showToast(message: '$action Success');
    } else {
      EasyOverlay.showToast(message: response.msg);
    }
  }

  void _report() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          context.isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 30,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Report User',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            ..._reportOptions.map(
              (item) => ListTile(
                dense: true,
                leading:
                    Icon(item.$2, color: Colors.redAccent, size: 18),
                title: Text(item.$1,
                    style: const TextStyle(fontSize: 13)),
                onTap: () => _submitReport(item.$1),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _submitReport(String reason) async {
    Navigator.pop(context);
    EasyOverlay.show();
    await Future.delayed(const Duration(seconds: 1));
    EasyOverlay.dismiss();
    EasyOverlay.showToast(message: 'Report submitted: $reason');
  }

  void _viewCover() {
    final cover = widget.message.sender?.cover;
    if (cover != null) Reusable.showImage(context, [cover], 0);
  }

  static const _reportOptions = [
    ('Inappropriate Content', Icons.warning_amber_rounded),
    ('Spam', Icons.block_rounded),
    ('Harassment', Icons.person_off_rounded),
    ('Fake Account', Icons.person_remove_rounded),
  ];
}

// ─────────────────────────────────────────
// ── Profile Card ──
// ─────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final dynamic sender;
  final bool isBlocked;
  final bool isDark;
  final VoidCallback onTapAvatar;

  const _ProfileCard({
    required this.sender,
    required this.isBlocked,
    required this.isDark,
    required this.onTapAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEFEFEF),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              GestureDetector(
                onTap: onTapAvatar,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFE8E4DF),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Opacity(
                          opacity: isBlocked ? 0.4 : 1.0,
                          child: NetworkImageView(
                            url: sender?.cover,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            fallbackAssets: Imgs.user,
                          ),
                        ),
                      ),
                    ),
                    if (isBlocked)
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE05555),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFFAFAFA),
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.block_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Name + status/blocked
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender?.name ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    isBlocked
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A1818)
                                  : const Color(0xFFFFF2F2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFCCCC),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE05555),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Blocked',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFE05555),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),

          // ID row
          const SizedBox(height: 12),
          Container(
            height: 0.5,
            color: isDark ? Colors.white10 : const Color(0xFFEBEBEB),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? Colors.white38
                      : const Color(0xFFAAAAAA),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF222222)
                      : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sender?.id?.substring(0, 12) ?? 'N/A',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: isDark
                        ? Colors.white54
                        : const Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// ── Action Group ──
// ─────────────────────────────────────────
class _ActionGroup extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _ActionGroup({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEBEBEB),
          width: 0.5,
        ),
      ),
      child: Column(children: children),
    );
  }
}

// ─────────────────────────────────────────
// ── Action Tile ──
// ─────────────────────────────────────────
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final Color? labelColor;
  final bool isDark;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    this.labelColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 15, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: labelColor ??
                      (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: isDark ? Colors.white24 : const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// ── Helpers ──
// ─────────────────────────────────────────
class _ActionDivider extends StatelessWidget {
  final bool isDark;
  const _ActionDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Container(
        height: 0.5,
        color: isDark ? Colors.white10 : const Color(0xFFF0F0F0),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _NavBtn({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF222222)
              : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isDark ? Colors.white60 : const Color(0xFF444444),
        ),
      ),
    );
  }
}