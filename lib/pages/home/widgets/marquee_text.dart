import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../../../data/models/config_model.dart';
import '../../../utils/extension.dart';
import '../../../utils/global.dart' as gb;
import '../../../utils/reusable.dart';

class MarqueeTxt extends StatelessWidget {
  final Color? textColor;
  final double? height;
  final BoxDecoration? decoration;
  const MarqueeTxt({
    super.key,
    this.decoration,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    MarqueeText? marquee = gb.Global.config.marqueeText;

    if (marquee == null) return SizedBox();

    if (marquee.content == null || marquee.content.toString().isEmpty) {
      return SizedBox();
    }

    return GestureDetector(
      onTap: () {
        if (marquee.url == null) return;
        Reusable.openURL(marquee.url);
      },
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.colors.primary,
        ),
        child: Marquee(
          text: marquee.content!,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            height: 2,
            color: Colors.white,
          ),
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          fadingEdgeEndFraction: 0.3,
          fadingEdgeStartFraction: 0.3,
          blankSpace: 100.0,
          velocity: 60.0,
          startPadding: 60,
          accelerationCurve: Curves.linear,
        ),
      ),
    );
  }
}
