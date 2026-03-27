import 'package:flutter/material.dart';
import '../../../utils/images.dart';

class ChatIcon extends StatelessWidget {
  const ChatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: Image.asset(
                Imgs.chatt,
                color: Colors.white,
                width: 30,
                height: 30,
              ),
            ),
          ),
          Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: const Text(
              "7",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
