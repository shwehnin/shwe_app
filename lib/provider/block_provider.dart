import 'package:flutter/material.dart';
import '../data/models/user_model.dart';

class BlockProvider extends ChangeNotifier {
  List<UserModel> list = [];

  int get listCount => list.length;

  void assign(List<UserModel> list) {
    this.list = list;
    notifyListeners();
  }

  void addAll(List<UserModel> list) {
    this.list.addAll(list);
    notifyListeners();
  }

  bool exist(String id) {
    return list.any((e) => e.id == id);
  }

  void add(UserModel item) {
    list.insert(0, item);
    notifyListeners();
  }

  void remove(UserModel item) {
    var idx = list.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      list.removeAt(idx);
      notifyListeners();
    }
  }

  void update(UserModel item) {
    var idx = list.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      list[idx] = item;
      notifyListeners();
    }
  }
}
