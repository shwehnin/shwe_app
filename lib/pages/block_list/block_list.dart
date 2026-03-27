import 'package:flutter/material.dart';
import '../../data/api/user_api.dart';
import '../../data/models/user_model.dart';
import '../../provider/block_provider.dart';
import '../../widgets/easy_overlay/easy_overlay.dart';
import '../../widgets/network_imge_view.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

class BlockList extends StatefulWidget {
  const BlockList({super.key});

  @override
  State<StatefulWidget> createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard4 : AppColors.lightBg3;
    final cardColor = isDark ? AppColors.darkCard3 : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Block List',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Consumer<BlockProvider>(
        builder: (ctx, pd, _) {
          var users = pd.list;
          return users.isEmpty
              ? _buildEmpty(isDark)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final user = users[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          NetworkImageView(
                            url: user.cover,
                            width: 45,
                            height: 45,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          const SizedBox(width: 12),
                          // Name
                          Expanded(
                            child: Text(
                              user.name ?? 'Unknown User',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          // Unblock
                          TextButton(
                            onPressed: () => _showUnblockDialog(user),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.red.withValues(
                                alpha: 0.08,
                              ),
                            ),
                            child: const Text(
                              'Unblock',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Blocked Users',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your block list is empty',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showUnblockDialog(UserModel user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard3 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Unblock User',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to unblock ${user.name ?? 'this user'}?',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              EasyOverlay.show();
              var response = await UserApi.removeFromBlockList(user: user);
              EasyOverlay.dismiss();
              if (response.status && mounted) {
                Provider.of<BlockProvider>(context, listen: false).remove(user);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text(
              'Unblock',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
