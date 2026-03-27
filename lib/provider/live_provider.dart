import 'package:flutter/material.dart';

import '../data/models/stock_model.dart';

class LiveProvider extends ChangeNotifier {
  late StockModel data;

  update(StockModel data) {
    this.data = data;
    notifyListeners();
  }
}
