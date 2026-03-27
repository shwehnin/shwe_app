class ThreeDModel {
  String? id;
  String? date;
  String? num;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ThreeDModel({
    this.id,
    this.date,
    this.num,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ThreeDModel.fromJson(Map<String, dynamic> json) => ThreeDModel(
        id: json['_id'] as String?,
        date: json['date'] as String?,
        num: json['num'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'date': date,
        'num': num,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  ThreeDModel copyWith({
    String? id,
    String? date,
    String? num,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ThreeDModel(
      id: id ?? this.id,
      date: date ?? this.date,
      num: num ?? this.num,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
