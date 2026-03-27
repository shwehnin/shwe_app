import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../utils/extension.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FToast fToast = FToast();

class EasyOverlay {
  static init() {
    if (navigatorKey.currentContext == null) return;
    fToast.init(navigatorKey.currentContext!);
  }

  static dismiss() {
    if (navigatorKey.currentContext == null) return;
    navigatorKey.currentContext!.pop();
  }

  static Future<dynamic> show({
    Widget? child,
    bool barrierDismissible = true,
  }) async {
    if (navigatorKey.currentContext == null) return;
    return showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: .5),
      context: navigatorKey.currentContext!,
      builder: (ctx) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child:
                child ??
                SizedBox(
                  width: 43,
                  height: 43,
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: (navigatorKey.currentContext!.isDarkMode
                        ? Colors.white
                        : Colors.black),
                    size: 43,
                  ),
                ),
          ),
        );
      },
    );
  }

  static showToast({required String message}) {
    fToast.removeQueuedCustomToasts();
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Text(message, style: TextStyle(color: Colors.white)),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
