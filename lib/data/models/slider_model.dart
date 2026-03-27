class SliderModel {
  final String? id;
  final String? cover;
  final String? url;
  const SliderModel({this.id, this.cover, this.url});
  SliderModel copyWith({String? id, String? cover, String? url}) {
    return SliderModel(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      url: url ?? this.url,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'cover': cover, 'url': url};
  }

  static SliderModel fromJson(Map<String, Object?> json) {
    return SliderModel(
      id: json['id'] == null ? null : json['id'] as String,
      cover: json['cover'] == null ? null : json['cover'] as String,
      url: json['url'] == null ? null : json['url'] as String,
    );
  }

  @override
  String toString() {
    return '''SliderModel(
                id:$id,
cover:$cover,
url:$url
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is SliderModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.cover == cover &&
        other.url == url;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, cover, url);
  }
}
