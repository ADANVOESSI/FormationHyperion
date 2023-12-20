import 'package:equatable/equatable.dart';
import 'package:pokemon/models/pokemon_type.dart';

sealed class TypesPokemonsEvent extends Equatable {
  const TypesPokemonsEvent();

  @override
  List<Object> get props => [];
}

class LoadTypesPokemons extends TypesPokemonsEvent {}

class FilterTypesSelected extends TypesPokemonsEvent {
  final PokemonType pokemonType;
  final bool isSelected;

  const FilterTypesSelected({
    required this.pokemonType,
    required this.isSelected,
  });

  @override
  List<Object> get props => [pokemonType, isSelected];
}
