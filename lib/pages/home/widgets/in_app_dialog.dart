import 'package:flutter/material.dart';
import '../../../utils/extension.dart';
import '../../../utils/global.dart';
import '../../../utils/reusable.dart';
import '../../../widgets/easy_overlay/easy_overlay.dart';
import '../../../widgets/network_imge_view.dart';

class InAppDialog extends StatelessWidget {
  const InAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final msg = Global.config.appMessage;
    final primary = context.colors.primaryFixed;

    return Center(
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
        margin: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image with close button ──
            if (msg?.showImage == true)
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: NetworkImageView(
                      height: double.infinity,
                      width: double.infinity,
                      url: msg?.cover,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Close X button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => EasyOverlay.dismiss(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                children: [
                  // Title
                  if (msg?.title != null && msg!.title!.isNotEmpty)
                    Text(
                      msg.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Body
                  if (msg?.content != null && msg!.content!.isNotEmpty)
                    Text(
                      msg.content!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),

            // ── Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  // Primary action
                  if (msg?.actionText != null && msg!.actionText!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          EasyOverlay.dismiss();
                          Reusable.openURL(msg.actionUrl);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          msg.actionText!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Dismiss
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () => EasyOverlay.dismiss(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ပိတ်မည်',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
