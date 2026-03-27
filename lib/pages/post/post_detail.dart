import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hyperlink/hyperlink.dart';
import '../../utils/reusable.dart';
import '../../data/models/post_model.dart';
import 'post_header.dart';
import 'post_image.dart';

class PostDetail extends StatefulWidget {
  final PostModel post;

  const PostDetail({super.key, required this.post});

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late PostModel post;

  @override
  void initState() {
    post = widget.post;
    super.initState();
  }

  bool get _hasValidThumbnail =>
      post.thumbnail?.isNotEmpty == true && post.showThumbnailInContent == true;

  List<String> get _allImages {
    final images = <String>[];

    if (_hasValidThumbnail) {
      images.add(post.thumbnail!);
    }

    if (post.images != null) {
      images.addAll(post.images!);
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              _buildHeader(),
              if (_hasContent) _buildContent(),
              if (_allImages.isNotEmpty) _buildImageList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: PostHeader(createdAt: post.createdAt!),
    );
  }

  Widget _buildContent() {
    var theme = AdaptiveTheme.of(context).mode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: HyperLink(
        text: post.content!,
        textAlign: TextAlign.left,
        textStyle: TextStyle(
          fontSize: 16,
          color: theme.isDark ? Colors.white : Colors.black87,
        ),
        linkCallBack: Reusable.openURL,
        linkStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: _allImages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return PostImage(url: _allImages, selectedIndx: index);
      },
    );
  }

  bool get _hasContent => post.content?.isNotEmpty == true;
}
