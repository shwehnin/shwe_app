import 'user_model.dart';

class CommentModel {
  final String? id;
  final String? content;
  final UserModel? user;
  final String? post;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CommentModel({
    this.id,
    this.content,
    this.user,
    this.post,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CommentModel copyWith({
    String? id,
    String? content,
    UserModel? user,
    String? post,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      user: user ?? this.user,
      post: post ?? this.post,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  CommentModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        content = json['content'] as String?,
        user = (json['user'] as Map<String, dynamic>?) != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        post = json['post'] as String?,
        createdAt = json['createdAt'] as String?,
        updatedAt = json['updatedAt'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'content': content,
        'user': user?.toJson(),
        'post': post,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v
      };
}
