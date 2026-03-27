class FrequencyModel {
  final String? title;
  final Map<String, dynamic>? result;

  FrequencyModel({
    this.title,
    this.result,
  });

  FrequencyModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        result = (json['result'] as Map<String, dynamic>?) != null
            ? json['result'] as Map<String, dynamic>
            : null;

  Map<String, dynamic> toJson() => {'title': title, 'result': result};
}
