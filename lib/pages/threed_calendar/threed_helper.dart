import '../../data/models/three_d_model.dart';

class ThreedHelper {
  ThreedHelper._();
  static final ThreedHelper _instance = ThreedHelper._();
  factory ThreedHelper() => _instance;

  List<ThreeDModel> threeDList = [];
  bool hasNextPage = true;
  int page = 1;

  reset() {
    threeDList.clear();
    hasNextPage = true;
    page = 1;
  }
}
