class MissModel {
  final String? title;
  final List<int>? result;

  MissModel({
    this.title,
    this.result,
  });

  MissModel.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String?,
      result = (json['result'] as List?)?.map((dynamic e) => e as int).toList();

  Map<String, dynamic> toJson() => {
    'title' : title,
    'result' : result
  };
}