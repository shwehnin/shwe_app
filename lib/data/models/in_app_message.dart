
class AppMessage {
  final String? title;
  final String? cover;
  final String? content;
  final String? version;
  final bool? isUpdate;
  final bool? showImage;
  final bool? showStatus;
  final String? actionUrl;
  final String? actionText;
  const AppMessage({
    this.title,
    this.cover,
    this.content,
    this.version,
    this.isUpdate,
    this.showImage,
    this.showStatus,
    this.actionUrl,
    this.actionText,
  });
  AppMessage copyWith({
    String? title,
    String? cover,
    String? content,
    String? version,
    bool? isUpdate,
    bool? showImage,
    bool? showStatus,
    String? actionUrl,
    String? actionText,
  }) {
    return AppMessage(
      title: title ?? this.title,
      cover: cover ?? this.cover,
      content: content ?? this.content,
      version: version ?? this.version,
      isUpdate: isUpdate ?? this.isUpdate,
      showImage: showImage ?? this.showImage,
      showStatus: showStatus ?? this.showStatus,
      actionUrl: actionUrl ?? this.actionUrl,
      actionText: actionText ?? this.actionText,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'cover': cover,
      'content': content,
      'version': version,
      'is_update': isUpdate,
      'show_image': showImage,
      'show_status': showStatus,
      'action_url': actionUrl,
      'action_text': actionText,
    };
  }

  static AppMessage fromJson(Map<String, Object?> json) {
    return AppMessage(
      title: json['title'] == null ? null : json['title'] as String,
      cover: json['cover'] == null ? null : json['cover'] as String,
      content: json['content'] == null ? null : json['content'] as String,
      version: json['version'] == null ? null : json['version'] as String,
      isUpdate: json['is_update'] == null ? null : json['is_update'] as bool,
      showImage: json['show_image'] == null ? null : json['show_image'] as bool,
      showStatus: json['show_status'] == null
          ? null
          : json['show_status'] as bool,
      actionUrl: json['action_url'] == null
          ? null
          : json['action_url'] as String,
      actionText: json['action_text'] == null
          ? null
          : json['action_text'] as String,
    );
  }

  @override
  String toString() {
    return '''AppMessage(
                title:$title,
cover:$cover,
content:$content,
version:$version,
isUpdate:$isUpdate,
showImage:$showImage,
showStatus:$showStatus,
actionUrl:$actionUrl,
actionText:$actionText
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is AppMessage &&
        other.runtimeType == runtimeType &&
        other.title == title &&
        other.cover == cover &&
        other.content == content &&
        other.version == version &&
        other.isUpdate == isUpdate &&
        other.showImage == showImage &&
        other.showStatus == showStatus &&
        other.actionUrl == actionUrl &&
        other.actionText == actionText;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      title,
      cover,
      content,
      version,
      isUpdate,
      showImage,
      showStatus,
      actionUrl,
      actionText,
    );
  }
}
