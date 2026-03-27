class PostModel {
  final String? content;
  final String? user;
  final String? thumbnail;
  final List<String>? images;
  final int? likeCount;
  final bool? showThumbnailInContent;
  final bool? isLiked;
  final int? commentCount;
  final bool? allowComment;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  PostModel({
    this.content,
    this.user,
    this.isLiked,
    this.thumbnail,
    this.allowComment,
    this.showThumbnailInContent,
    this.images,
    this.likeCount,
    this.commentCount,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PostModel copyWith({
    String? content,
    String? user,
    String? thumbnail,
    bool? showThumbnailInContent,
    bool? allowComment,
    List<String>? images,
    int? likeCount,
    int? commentCount,
    String? id,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return PostModel(
      content: content ?? this.content,
      user: user ?? this.user,
      thumbnail: thumbnail ?? this.thumbnail,
      showThumbnailInContent:
          showThumbnailInContent ?? this.showThumbnailInContent,
      allowComment: allowComment ?? this.allowComment,
      images: images ?? this.images,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  PostModel.fromJson(Map<String, dynamic> json)
      : content = json['content'] as String?,
        user = json['user'] as String?,
        isLiked = json['is_liked'] as bool?,
        thumbnail = json['thumbnail'] as String?,
        allowComment = json['allow_comment'] as bool?,
        showThumbnailInContent = json['show_thumbnail_in_content'] as bool?,
        images =
            (json['images'] as List?)?.map((dynamic e) => e as String).toList(),
        likeCount = json['like_count'] as int?,
        commentCount = json['comment_count'] as int?,
        id = json['_id'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        'content': content,
        'user': user,
        'thumbnail': thumbnail,
        'images': images,
        'like_count': likeCount,
        'allow_comment': allowComment,
        'show_thumbnail_in_content': showThumbnailInContent,
        // 'comment_count': commentCount,
        // '_id': id,
        // 'createdAt': createdAt,
        // 'updatedAt': updatedAt,
        // '__v': v
      };
}
