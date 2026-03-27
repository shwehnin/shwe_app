import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  final String content;
  final bool haveDetailImage;
  const PostContent({
    super.key,
    required this.content,
    required this.haveDetailImage,
  });

  @override
  Widget build(BuildContext context) {
    var theme = AdaptiveTheme.of(context).mode;
    // Calculate if we need "See More" by checking if text would overflow
    final textSpan = TextSpan(
      text: content,
      style: TextStyle(fontSize: 16, height: 1.4),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 4,
    );

    // Use a reasonable width for calculation
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);

    final isTextOverflowing = textPainter.didExceedMaxLines;

    if (!isTextOverflowing) {
      // Text fits in maxLines, show normally
      return Container(
        width: double.infinity,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: theme.isDark ? Colors.white : Colors.black87,
            ),
            children: [
              TextSpan(text: content),
              if (haveDetailImage) TextSpan(text: '... '),
              if (haveDetailImage)
                WidgetSpan(
                  child: Text(
                    'See More',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // child: Row(
        //   children: [
        //     Text(
        //       content,
        //       style: TextStyle(
        //         fontSize: 16,
        //         height: 1.4,
        //         // color: Colors.black87,
        //       ),
        //     ),
        //     if (haveDetailImage)
        //       Text(
        //         '...See Detail Images',
        //         style: TextStyle(
        //           fontSize: 16,
        //           color: Colors.grey[600],
        //           fontWeight: FontWeight.w500,
        //         ),
        //       )
        //   ],
        // ),
      );
    }

    // Text overflows, show truncated version with See More
    final words = content.split(' ');
    String truncatedText = '';

    // Build truncated text that fits in maxLines - some space for "See More"
    for (int i = 0; i < words.length; i++) {
      final testText =
          '$truncatedText${truncatedText.isEmpty ? '' : ' '}${words[i]}... See More';
      final testSpan = TextSpan(
        text: testText,
        style: TextStyle(fontSize: 16, height: 1.4),
      );

      final testPainter = TextPainter(
        text: testSpan,
        textDirection: TextDirection.ltr,
        maxLines: 4,
      );

      testPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);

      if (testPainter.didExceedMaxLines) {
        break;
      }

      truncatedText += (truncatedText.isEmpty ? '' : ' ') + words[i];
    }

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
            color: theme.isDark ? Colors.white : Colors.black87,
          ),
          children: [
            TextSpan(text: truncatedText),
            TextSpan(text: '... '),
            WidgetSpan(
              child: Text(
                'See More',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
