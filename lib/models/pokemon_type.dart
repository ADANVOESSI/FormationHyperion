class PokemonType {
  final int? id;
  final String name;
  final String imageUrl;

  PokemonType({required this.name, required this.imageUrl, this.id});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      id: json['id'] as int?,
      name: json['name'] as String,
      imageUrl: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
    };
  }
}
