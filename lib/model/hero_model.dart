class HeroModel {
  final int id;
  final String name;
  final Map<String, dynamic> powerstats;

  HeroModel({
    required this.id,
    required this.name,
    required this.powerstats,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      powerstats: json['powerstats'] is Map
          ? Map<String, dynamic>.from(json['powerstats'])
          : {},
    );
  }
}
