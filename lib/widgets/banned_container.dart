import 'package:flutter/material.dart';

class BannedContainerCard extends StatelessWidget {
  const BannedContainerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha:0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: 45,
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.block,
                size: 100,
                color: Colors.red.withValues(alpha:0.08),
              ),
            ),
             Positioned(
              left: -20,
              bottom: -20,
              child: Icon(
                Icons.block,
                size: 100,
                color: Colors.red.withValues(alpha:0.08),
              ),
            ),
            Center(
              child: Text(
                "Access Restricted",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
