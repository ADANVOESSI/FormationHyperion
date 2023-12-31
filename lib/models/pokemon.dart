import 'pokemon_type.dart';

class Pokemon {
   int id;
   String name;
   String imageUrl;
  final List<PokemonType> types;

  Pokemon({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
  });

   bool isValid() => name.isNotEmpty && imageUrl.isNotEmpty && types.isNotEmpty;

   factory Pokemon.fromJson(Map<String, dynamic> json) {
    final jsonTypesArray = json['apiTypes'] as List? ?? [];
    final types =
    jsonTypesArray.map((type) => PokemonType.fromJson(type)).toList();
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'],
      types: types,
    );
  }

  @override
  String toString() {
    return '${name.padRight(15)} | [${types.map((t) => t.name).join(',')}]';
  }
}
