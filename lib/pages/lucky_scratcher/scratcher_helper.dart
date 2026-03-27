import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:new_lion/data/models/scratch_model.dart';
import 'package:new_lion/utils/shared_pref.dart';

const scratcherKey = "SCRATCHER_KEY";

class ScratcherHelper {
  static Future<ScratchModel> _savedData() async {
    var data = await SharedPref.getData(key: scratcherKey);
    if (data == null) return await _saveNew();
    var scratchModel = ScratchModel.fromJson(jsonDecode(data));
    var today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    if (today != scratchModel.date) {
      await SharedPref.clearData(key: scratcherKey);
      return await _saveNew();
    }
    return scratchModel;
  }

  static Future<ScratchModel> _saveNew() async {
    var today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final scratchModel = ScratchModel(date: today, scratchCards: []);
    await SharedPref.setData(
      value: jsonEncode(scratchModel.toJson()),
      key: scratcherKey,
    );
    return scratchModel;
  }

  static Future<ScratchCards?> checkScratchedById({required int id}) async {
    ScratchModel scratchModel = await _savedData();
    var cards = scratchModel.scratchCards ?? [];
    var idx = cards.indexWhere((e) => e.id == id);
    if (idx != -1) return cards[idx];
    return null;
  }

  static Future<void> saveNewCard({
    required int id,
    required String nums,
  }) async {
    ScratchModel scratchModel = await _savedData();
    var cards = scratchModel.scratchCards ?? [];
    var idx = cards.indexWhere((e) => e.id == id);
    if (idx == -1) {
      var data = scratchModel.copyWith(scratchCards: [
        ...cards,
        ScratchCards(id: id, nums: nums),
      ]);
      await SharedPref.setData(
        value: jsonEncode(data.toJson()),
        key: scratcherKey,
      );
    }
  }
}
