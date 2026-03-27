import 'package:flutter/material.dart';
import 'set_value_helper.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/blinker.dart';

class SetValueText extends StatelessWidget {
  final String text;
  final bool isBlink;
  final bool isSET;
  final Color? color;
  const SetValueText({
    super.key,
    required this.text,
    this.isBlink = false,
    required this.isSET,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return text == "--"
        ? Text(
            "---",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          )
        : Blinker(
            isActive: isBlink,
            child: isSET
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: SetValHelper.setPrefix(text),
                      style: TextStyle(
                        color: color ?? Colors.white,
                        fontSize: 18,
                        fontFamily: Fonts.en,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: SetValHelper.setSuffix(text),
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: SetValHelper.valuePrefix(text),
                      style: TextStyle(
                        color: color ?? Colors.white,
                        fontSize: 18,
                        fontFamily: Fonts.en,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: SetValHelper.valueMiddle(text),
                          children: [
                            TextSpan(
                              text: SetValHelper.valueSuffix(text),
                              style: TextStyle(
                                color: color ?? Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
