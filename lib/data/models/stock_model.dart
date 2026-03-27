class StockModel {
  final bool? isRunning;
  final String? currentState;
  final String? updateDesc;
  final String? date;
  final Round? round1;
  final Round? round2;
  final Of930? of930;
  final Of930? of200;
  final String? tw1;
  const StockModel({
    this.isRunning,
    this.currentState,
    this.updateDesc,
    this.date,
    this.round1,
    this.round2,
    this.of930,
    this.of200,
    this.tw1,
  });
  StockModel copyWith({
    bool? isRunning,
    String? currentState,
    String? updateDesc,
    String? date,
    Round? round1,
    Round? round2,
    Of930? of930,
    Of930? of200,
    String? tw1,
  }) {
    return StockModel(
      isRunning: isRunning ?? this.isRunning,
      currentState: currentState ?? this.currentState,
      updateDesc: updateDesc ?? this.updateDesc,
      date: date ?? this.date,
      round1: round1 ?? this.round1,
      round2: round2 ?? this.round2,
      of930: of930 ?? this.of930,
      of200: of200 ?? this.of200,
      tw1: tw1 ?? this.tw1,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'is_running': isRunning,
      'current_state': currentState,
      'update_desc': updateDesc,
      'date': date,
      'round_1': round1?.toJson(),
      'round_2': round2?.toJson(),
      'of_9_30': of930?.toJson(),
      'of_2_00': of200?.toJson(),
      'tw_1': tw1,
    };
  }

  static StockModel fromJson(Map<String, Object?> json) {
    return StockModel(
      isRunning: json['is_running'] == null ? null : json['is_running'] as bool,
      currentState: json['current_state'] == null
          ? null
          : json['current_state'] as String,
      updateDesc: json['update_desc'] == null
          ? null
          : json['update_desc'] as String,
      date: json['date'] == null ? null : json['date'] as String,
      round1: json['round_1'] == null
          ? null
          : Round.fromJson(json['round_1'] as Map<String, Object?>),
      round2: json['round_2'] == null
          ? null
          : Round.fromJson(json['round_2'] as Map<String, Object?>),
      of930: json['of_9_30'] == null
          ? null
          : Of930.fromJson(json['of_9_30'] as Map<String, Object?>),
      of200: json['of_2_00'] == null
          ? null
          : Of930.fromJson(json['of_2_00'] as Map<String, Object?>),
      tw1: json['tw_1'] == null ? null : json['tw_1'] as String,
    );
  }

  @override
  String toString() {
    return '''StockModel(
                isRunning:$isRunning,
currentState:$currentState,
updateDesc:$updateDesc,
date:$date,
round1:${round1.toString()},
round2:${round2.toString()},
of930:${of930.toString()},
of200:${of200.toString()},
tw1:$tw1
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is StockModel &&
        other.runtimeType == runtimeType &&
        other.isRunning == isRunning &&
        other.currentState == currentState &&
        other.updateDesc == updateDesc &&
        other.date == date &&
        other.round1 == round1 &&
        other.round2 == round2 &&
        other.of930 == of930 &&
        other.of200 == of200 &&
        other.tw1 == tw1;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      isRunning,
      currentState,
      updateDesc,
      date,
      round1,
      round2,
      of930,
      of200,
      tw1,
    );
  }
}

class Of930 {
  final String? modern;
  final String? internet;
  const Of930({this.modern, this.internet});
  Of930 copyWith({String? modern, String? internet}) {
    return Of930(
      modern: modern ?? this.modern,
      internet: internet ?? this.internet,
    );
  }

  Map<String, Object?> toJson() {
    return {'modern': modern, 'internet': internet};
  }

  static Of930 fromJson(Map<String, Object?> json) {
    return Of930(
      modern: json['modern'] == null ? null : json['modern'] as String,
      internet: json['internet'] == null ? null : json['internet'] as String,
    );
  }

  @override
  String toString() {
    return '''Of930(
                modern:$modern,
internet:$internet
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Of930 &&
        other.runtimeType == runtimeType &&
        other.modern == modern &&
        other.internet == internet;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, modern, internet);
  }
}

class Round {
  final String? set;
  final String? value;
  const Round({this.set, this.value});
  Round copyWith({String? set, String? value}) {
    return Round(set: set ?? this.set, value: value ?? this.value);
  }

  Map<String, Object?> toJson() {
    return {'set': set, 'value': value};
  }

  static Round fromJson(Map<String, Object?> json) {
    return Round(
      set: json['set'] == null ? null : json['set'] as String,
      value: json['value'] == null ? null : json['value'] as String,
    );
  }

  @override
  String toString() {
    return '''Round(
                set:$set,
value:$value
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Round &&
        other.runtimeType == runtimeType &&
        other.set == set &&
        other.value == value;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, set, value);
  }
}
