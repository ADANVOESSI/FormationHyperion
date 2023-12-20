import 'package:equatable/equatable.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';

sealed class PokemonsEvent extends Equatable {
  const PokemonsEvent();

  @override
  List<Object> get props => [];
}

class LoadPokemons extends PokemonsEvent {}

class PokemonSelected extends PokemonsEvent {
  final Pokemon selectedPokemon;

  const PokemonSelected(this.selectedPokemon);

  @override
  List<Object> get props => [selectedPokemon];
}

class AddPokemon extends PokemonsEvent {
  final String name;
  final String imageUrl;
  final List<PokemonType> types;

  const AddPokemon({
    required this.name,
    required this.imageUrl,
    required this.types,
  });
}

class PokemonsDeleted extends PokemonsEvent {
  final int index;

  const PokemonsDeleted({required this.index});

  @override
  List<Object> get props => [index];
}

class DeleteAllPokemons extends PokemonsEvent {}

class SearchPokemon extends PokemonsEvent {
  final String searchText;

  const SearchPokemon(this.searchText);

  @override
  List<Object> get props => [searchText];
}
