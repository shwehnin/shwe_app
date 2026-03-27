class UserModel {
  final String? id;
  final String? email;
  final String? cover;
  final String? bio;
  final bool? isBanned;
  final int? reportCount;
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final int? V;
  const UserModel({
    this.id,
    this.email,
    this.cover,
    this.bio,
    this.isBanned,
    this.reportCount,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.V,
  });
  UserModel copyWith({
    String? id,
    String? email,
    String? cover,
    String? bio,
    bool? isBanned,
    int? reportCount,
    String? name,
    String? createdAt,
    String? updatedAt,
    int? V,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      cover: cover ?? this.cover,
      bio: bio ?? this.bio,
      isBanned: isBanned ?? this.isBanned,
      reportCount: reportCount ?? this.reportCount,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      V: V ?? this.V,
    );
  }

  Map<String, Object?> toJson() {
    return {
      '_id': id,
      'email': email,
      'cover': cover,
      'bio': bio,
      'is_banned': isBanned,
      'report_count': reportCount,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': V,
    };
  }

  static UserModel fromJson(Map<String, Object?> json) {
    return UserModel(
      id: json['_id'] == null ? null : json['_id'] as String,
      email: json['email'] == null ? null : json['email'] as String,
      cover: json['cover'] == null ? null : json['cover'] as String,
      bio: json['bio'] == null ? null : json['bio'] as String,
      isBanned: json['is_banned'] == null ? null : json['is_banned'] as bool,
      reportCount: json['report_count'] == null
          ? null
          : json['report_count'] as int,
      name: json['name'] == null ? null : json['name'] as String,
      createdAt: json['createdAt'] == null ? null : json['createdAt'] as String,
      updatedAt: json['updatedAt'] == null ? null : json['updatedAt'] as String,
      V: json['__v'] == null ? null : json['__v'] as int,
    );
  }

  @override
  String toString() {
    return '''UserModel(
                id:$id,
email:$email,
cover:$cover,
bio:$bio,
isBanned:$isBanned,
reportCount:$reportCount,
name:$name,
createdAt:$createdAt,
updatedAt:$updatedAt,
V:$V
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is UserModel &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.email == email &&
        other.cover == cover &&
        other.bio == bio &&
        other.isBanned == isBanned &&
        other.reportCount == reportCount &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.V == V;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      email,
      cover,
      bio,
      isBanned,
      reportCount,
      name,
      createdAt,
      updatedAt,
      V,
    );
  }
}
