class ScratchModel {
  final String? date;
  final List<ScratchCards>? scratchCards;

  ScratchModel({
    this.date,
    this.scratchCards,
  });

  ScratchModel copyWith({
    String? date,
    List<ScratchCards>? scratchCards,
  }) {
    return ScratchModel(
      date: date ?? this.date,
      scratchCards: scratchCards ?? this.scratchCards,
    );
  }

  ScratchModel.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String?,
        scratchCards = (json['scratch_cards'] as List?)
            ?.map(
                (dynamic e) => ScratchCards.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'date': date,
        'scratch_cards': scratchCards?.map((e) => e.toJson()).toList()
      };
}

class ScratchCards {
  final int? id;
  final String? nums;

  ScratchCards({
    this.id,
    this.nums,
  });

  ScratchCards copyWith({
    int? id,
    String? nums,
  }) {
    return ScratchCards(
      id: id ?? this.id,
      nums: nums ?? this.nums,
    );
  }

  ScratchCards.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        nums = json['nums'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'nums': nums};
}
