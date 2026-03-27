import 'package:flutter/material.dart';
import '../../utils/images.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeader extends StatelessWidget {
  final String createdAt;
  const PostHeader({super.key, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: Image.asset(Imgs.icon, width: 35, height: 35),
        ),
        SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "2D MM Lucky7",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              timeago.format(DateTime.parse(createdAt).toLocal()),
              style: TextStyle(height: 1, fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
