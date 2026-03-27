import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../admob/ad_helper.dart';
import '../../config/routes/route_locations.dart';
import '../../utils/extension.dart';
import '../../utils/images.dart';
import '../../data/models/post_model.dart';
import '../../data/api/post_api.dart';
import 'post_content.dart';
import 'post_header.dart';
import 'post_image_grid.dart';
import 'comments_page.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLike = false;
  num likeCount = 0;

  @override
  void initState() {
    super.initState();
    isLike = widget.post.isLiked ?? false;
    likeCount = widget.post.likeCount ?? 0;
  }

  void _detail() {
    AdHelper.showInterstitialAd(
      onComplete: () {
        context.pushNamed(RouteLocation.postDetail, extra: widget.post);
      },
    );
  }

  void _toggleLike() async {
    setState(() {
      isLike = !isLike;
      likeCount += isLike ? 1 : -1;
    });
    await PostApi.toggleLike(post: widget.post.id!);
  }

  void _navigateToComments() {
    if (widget.post.allowComment != true) return;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CommentsPage(post: widget.post),
        ),
      ),
    );
  }

  /// Check if post has any photos
  bool get _hasPhotos {
    final hasThumbnail =
        widget.post.thumbnail != null && widget.post.thumbnail!.isNotEmpty;
    final hasImages =
        widget.post.images != null && widget.post.images!.isNotEmpty;
    return hasThumbnail || hasImages;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header + Content (tappable to detail)
        GestureDetector(
          onTap: _detail,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeader(createdAt: widget.post.createdAt!),
                const SizedBox(height: 10),
                if (widget.post.content != null &&
                    widget.post.content!.isNotEmpty)
                  PostContent(
                    content: widget.post.content!,
                    haveDetailImage: _hasPhotos,
                  ),
              ],
            ),
          ),
        ),

        // Photo Grid (tappable to detail)
        if (_hasPhotos) ...[
          const SizedBox(height: 10),
          PostImageGrid(
            thumbnail: widget.post.thumbnail,
            images: widget.post.images ?? [],
            onTap: _detail,
          ),
        ],

        const SizedBox(height: 4),

        // Like & Comment row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Like
              Expanded(
                child: InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isLike
                          ? Colors.blue.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isLike ? Imgs.likeFill : Imgs.likeOutline,
                          color: isLike ? Colors.blue : Colors.grey[600],
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          likeCount.toK(),
                          style: TextStyle(
                            color: isLike ? Colors.blue : null,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Comment
              if (widget.post.allowComment == true)
                Expanded(
                  child: InkWell(
                    onTap: _navigateToComments,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Imgs.comment,
                            color: Colors.grey[600],
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.post.commentCount} Comment',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Divider
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          width: double.infinity,
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
