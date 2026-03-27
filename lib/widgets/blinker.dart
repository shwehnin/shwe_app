import 'dart:async';
import 'package:flutter/material.dart';
// --- Global controller ---

/*
Start once (e.g. in main or splash screen)
BlinkController.instance.start(
  visibleDuration: Duration(seconds: 2),
  hiddenDuration: Duration(milliseconds: 300),
);
*/
class BlinkController {
  BlinkController._();
  static final BlinkController instance = BlinkController._();

  final ValueNotifier<bool> visible = ValueNotifier<bool>(true);
  Timer? _timer;
  Duration _visibleDuration = const Duration(seconds: 2);
  Duration _hiddenDuration = const Duration(milliseconds: 300);

  void start({Duration? visibleDuration, Duration? hiddenDuration}) {
    if (visibleDuration != null) _visibleDuration = visibleDuration;
    if (hiddenDuration != null) _hiddenDuration = hiddenDuration;
    _timer?.cancel();
    visible.value = true;
    _scheduleNext();
  }

  void stop() {
    _timer?.cancel();
    visible.value = true;
  }

  void _scheduleNext() {
    final duration = visible.value ? _visibleDuration : _hiddenDuration;
    _timer = Timer(duration, () {
      visible.value = !visible.value;
      _scheduleNext();
    });
  }
}

// --- Widget ---

class Blinker extends StatelessWidget {
  final Widget child;
  final bool isActive;

  const Blinker({super.key, required this.child, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    if (!isActive) return child;

    return ValueListenableBuilder<bool>(
      valueListenable: BlinkController.instance.visible,
      builder: (_, visible, child) => AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: child,
      ),
      child: child,
    );
  }
}
