class SETModel {
  final String? date;
  final String? description;
  const SETModel({this.date, this.description});
  SETModel copyWith({String? date, String? description}) {
    return SETModel(
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, Object?> toJson() {
    return {'date': date, 'description': description};
  }

  static SETModel fromJson(Map<String, Object?> json) {
    return SETModel(
      date: json['date'] == null ? null : json['date'] as String,
      description: json['description'] == null
          ? null
          : json['description'] as String,
    );
  }

  @override
  String toString() {
    return '''SETModel(
                date:$date,
description:$description
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is SETModel &&
        other.runtimeType == runtimeType &&
        other.date == date &&
        other.description == description;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, date, description);
  }
}
