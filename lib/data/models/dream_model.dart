class Dream {
  final int no;
  final String name;
  final String cover;
  final List<int> numbers;

  Dream({
    required this.no,
    required this.name,
    required this.cover,
    required this.numbers,
  });

  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
      no: json['no'] as int,
      name: json['name'] as String,
      cover: json['cover'] as String,
      numbers: List<int>.from(json['numbers'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {'no': no, 'name': name, 'cover': cover, 'numbers': numbers};
  }
}
