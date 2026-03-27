import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../data/models/config_model.dart';
import '../utils/global.dart';
import '../utils/reusable.dart';

class MarqueeView extends StatelessWidget {
  final Color? textColor;
  final double? height;
  final BoxDecoration? decoration;
  const MarqueeView({super.key, this.decoration, this.textColor, this.height});

  @override
  Widget build(BuildContext context) {
    MarqueeText? marquee = Global.config.marqueeText;

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
          // color: context.colors.primaryFixed,
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
