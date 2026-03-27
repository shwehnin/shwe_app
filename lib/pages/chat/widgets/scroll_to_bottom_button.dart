import 'package:flutter/material.dart';
import '../../../utils/extension.dart';

class ScrollToBottomButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScrollToBottomButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                context.colors.primaryFixed,
                context.colors.primaryFixed.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 25,
            ),
            iconSize: 28,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }
}
