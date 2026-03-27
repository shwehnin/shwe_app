import 'package:flutter/material.dart';
import '../utils/const.dart';
import '../utils/images.dart';
import 'package:extended_image/extended_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NetworkImageView extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? fallbackAssets;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  const NetworkImageView({
    super.key,
    this.borderRadius,
    this.url,
    this.fit,
    this.width,
    this.fallbackAssets,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final logoIMG = Image.asset(
      fallbackAssets ?? Imgs.defaultImage,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: url == null
          ? logoIMG
          : ExtendedImage.network(
              !url!.startsWith("http") ? '${Const.storageURL}/$url' : url!,
              width: width,
              height: height,
              fit: fit ?? BoxFit.fill,
              alignment: alignment,
              cache: true,
              loadStateChanged: (state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return Shimmer(
                      duration: const Duration(milliseconds: 1800),
                      interval: const Duration(milliseconds: 200),
                      color: Colors.white,
                      colorOpacity: .2,
                      enabled: true,
                      child: logoIMG,
                    );
                  case LoadState.failed:
                    return logoIMG;
                  default:
                }
                return null;
              },
            ),
    );
  }
}
