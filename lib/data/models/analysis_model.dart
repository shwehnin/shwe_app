import 'frequency_model.dart';
import 'miss_model.dart';

class AnalysisModel {
  final FrequencyModel? frequency;
  final MissModel? miss;

  AnalysisModel({this.frequency, this.miss});

  AnalysisModel.fromJson(Map<String, dynamic> json)
    : frequency = (json['frequency'] as Map<String, dynamic>?) != null
          ? FrequencyModel.fromJson(json['frequency'] as Map<String, dynamic>)
          : null,
      miss = (json['miss_number'] as Map<String, dynamic>?) != null
          ? MissModel.fromJson(json['miss_number'] as Map<String, dynamic>)
          : null;
}
