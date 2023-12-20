import 'package:equatable/equatable.dart';

import '../../models/pokemon_type.dart';

sealed class TypesPokemonsEvent extends Equatable {
  const TypesPokemonsEvent();

  @override
  List<Object> get props => [];
}

class LoadTypesPokemons extends TypesPokemonsEvent {}

class FilterChipSelected extends TypesPokemonsEvent {
  final PokemonType pokemonType;
  final bool isSelected;

  const FilterChipSelected({
    required this.pokemonType,
    required this.isSelected,
  });

  @override
  List<Object> get props => [pokemonType, isSelected];
}

class AddPokemon extends TypesPokemonsEvent {
  final String name;
  final String imageUrl;
  final List<PokemonType> types;

  const AddPokemon({
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  @override
  List<Object> get props => [name, imageUrl, types];
}
