import 'package:flutter/material.dart';
import '../utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingView extends StatelessWidget {
  final Color? color;
  const LoadingView({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = context.isDarkMode;
    return Center(
      child: SizedBox(
        width: 43,
        height: 43,
        child: LoadingAnimationWidget.fourRotatingDots(
          color: color ?? (isDarkMode ? Colors.white : Colors.black),
          size: 43,
        ),
      ),
    );
  }
}
