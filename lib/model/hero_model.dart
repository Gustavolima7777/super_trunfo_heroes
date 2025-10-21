class HeroModel {
  final int id;
  final String name;
  final Map<String, dynamic> powerstats;
  final String imageUrl; // campo para armazenar a URL da imagem

  HeroModel({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.imageUrl,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      powerstats: json['powerstats'] is Map
          ? Map<String, dynamic>.from(json['powerstats'])
          : {},
      imageUrl: json['images'] != null && json['images']['md'] != null
          ? json['images']['md']
          : '',
    );
  }
}
