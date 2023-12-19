import '../../models/pokemon_type.dart';

class ThemeDataState {
  final String name;
  final String imageUrl;
  final List<PokemonType> types;

  ThemeDataState({
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  ThemeDataState copyWith({
    String? name,
    String? imageUrl,
    List<PokemonType>? types,
  }) {
    return ThemeDataState(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
    );
  }
}
