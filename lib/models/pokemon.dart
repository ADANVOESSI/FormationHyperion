import 'package:pokemon/models/pokemon_type.dart';

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

  factory Pokemon.fromJson(
    Map<String, dynamic> json, {
    String dataSource = 'api',
  }) {
    final jsonTypesKey = (dataSource == 'api') ? 'apiTypes' : 'types';
    final jsonTypesArray = json[jsonTypesKey] as List? ?? [];
    final types = jsonTypesArray.map((json) => PokemonType.fromJson(json as Map<String, dynamic>)).toList();
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image'] as String,
      types: types,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'types': types.map((type) => type.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '${name.padRight(15)} | [${types.map((t) => t.name).join(',')}]';
  }
}
