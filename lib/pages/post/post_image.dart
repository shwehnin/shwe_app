import 'package:flutter/material.dart';
import '../../utils/reusable.dart';
import '../../widgets/network_imge_view.dart';

class PostImage extends StatelessWidget {
  final List<String> url;
  final int selectedIndx;
  final EdgeInsetsGeometry? margin;
  const PostImage({super.key, required this.url, this.selectedIndx = 0,this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Reusable.showImage(context, url, selectedIndx);
      },
      child: Container(
        margin:margin?? EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(maxHeight: double.infinity),
        child: NetworkImageView(
          url: url[selectedIndx],
          height: null,
          width: double.infinity,
          fit: BoxFit.cover,
          //  borderRadius: BorderRadius.circular(isDetail ? 0 : 12),
        ),
      ),
    );
  }
}
