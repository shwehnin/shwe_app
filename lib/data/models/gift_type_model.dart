class GiftTypeModel {
  final String? id;
  final String? cover;
  final String? name;
  final String? adsType;
  const GiftTypeModel({this.id, this.cover, this.name, this.adsType});
  GiftTypeModel copyWith({
    String? id,
    String? cover,
    String? name,
    String? adsType,
  }) {
    return GiftTypeModel(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      adsType: adsType ?? this.adsType,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'cover': cover, 'name': name, 'ads_type': 'adsType'};
  }

  static GiftTypeModel fromJson(Map<String, Object?> json) {
    return GiftTypeModel(
      id: json['id'] == null ? null : json['id'] as String,
      cover: json['cover'] == null ? null : json['cover'] as String,
      name: json['name'] == null ? null : json['name'] as String,
      adsType: json['ads_type'] == null ? null : json['ads_type'] as String,
    );
  }

  @override
  String toString() {
    return '''GiftTypeModel(
                id:$id,
cover:$cover,
name:$name
ads_type:$adsType
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is GiftTypeModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.cover == cover &&
        other.name == name &&
        other.adsType == adsType;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, cover, name, adsType);
  }
}
