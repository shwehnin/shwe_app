class LottoThaiModel {
  final String? date;
  final Prize? prize;

  LottoThaiModel({
    this.date,
    this.prize,
  });

  LottoThaiModel.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String?,
        prize = (json['prize'] as Map<String, dynamic>?) != null
            ? Prize.fromJson(json['prize'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'date': date, 'prize': prize?.toJson()};
}

class Prize {
  final String? firstPrize;
  final List<String>? nearFirstPrize;
  final List<String>? first3Digits;
  final List<String>? last3Digits;
  final String? last2Digits;
  final List<String>? secondPrize;
  final List<String>? thirdPrize;
  final List<String>? fourthPrize;
  final List<String>? fifthPrize;

  Prize({
    this.firstPrize,
    this.nearFirstPrize,
    this.first3Digits,
    this.last3Digits,
    this.last2Digits,
    this.secondPrize,
    this.thirdPrize,
    this.fourthPrize,
    this.fifthPrize,
  });

  Prize.fromJson(Map<String, dynamic> json)
      : firstPrize = json['first_prize'] as String?,
        nearFirstPrize = (json['near_first_prize'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        first3Digits = (json['first_3_digits'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        last3Digits = (json['last_3_digits'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        last2Digits = json['last_2_digits'] as String?,
        secondPrize = (json['second_prize'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        thirdPrize = (json['third_prize'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        fourthPrize = (json['fourth_prize'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        fifthPrize = (json['fifth_prize'] as List?)
            ?.map((dynamic e) => e as String)
            .toList();

  Map<String, dynamic> toJson() => {
        'first_prize': firstPrize,
        'near_first_prize': nearFirstPrize,
        'first_3_digits': first3Digits,
        'last_3_digits': last3Digits,
        'last_2_digits': last2Digits,
        'second_prize': secondPrize,
        'third_prize': thirdPrize,
        'fourth_prize': fourthPrize,
        'fifth_prize': fifthPrize
      };
}
