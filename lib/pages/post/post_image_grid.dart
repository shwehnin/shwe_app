import 'package:flutter/material.dart';
import '../../widgets/network_imge_view.dart';

class PostImageGrid extends StatelessWidget {
  final String? thumbnail;
  final List<String> images;
  final VoidCallback onTap;

  const PostImageGrid({
    super.key,
    this.thumbnail,
    required this.images,
    required this.onTap,
  });

  /// Combine thumbnail + images into one list
  List<String> get _allPhotos {
    final list = <String>[];
    if (thumbnail != null && thumbnail!.isNotEmpty) {
      list.add(thumbnail!);
    }
    list.addAll(images);
    // Remove duplicates
    return list.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final photos = _allPhotos;
    if (photos.isEmpty) return const SizedBox.shrink();

    final count = photos.length;
    final extra = count > 4 ? count - 4 : 0;
    final show = count > 4 ? 4 : count;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: count == 1 ? 220 : 260,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: _buildLayout(photos, show, extra),
      ),
    );
  }

  Widget _buildLayout(List<String> photos, int show, int extra) {
    switch (show) {
      case 1:
        return _ImageTile(url: photos[0]);
      case 2:
        return Row(
          children: [
            Expanded(child: _ImageTile(url: photos[0])),
            const SizedBox(width: 2),
            Expanded(child: _ImageTile(url: photos[1])),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(flex: 2, child: _ImageTile(url: photos[0])),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _ImageTile(url: photos[1])),
                  const SizedBox(height: 2),
                  Expanded(
                    child: _ImageTile(
                      url: photos[2],
                      overlay: extra > 0 ? '+$extra' : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default: // 4+
        return Row(
          children: [
            Expanded(flex: 2, child: _ImageTile(url: photos[0])),
            const SizedBox(width: 2),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _ImageTile(url: photos[1])),
                  const SizedBox(height: 2),
                  Expanded(child: _ImageTile(url: photos[2])),
                  const SizedBox(height: 2),
                  Expanded(
                    child: _ImageTile(
                      url: photos[3],
                      overlay: extra > 0 ? '+$extra' : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }
}

/// Single image tile with optional "+N" overlay
class _ImageTile extends StatelessWidget {
  final String url;
  final String? overlay;

  const _ImageTile({required this.url, this.overlay});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        NetworkImageView(
          url: url,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        if (overlay != null)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            alignment: Alignment.center,
            child: Text(
              overlay!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
