import 'package:equatable/equatable.dart';
import 'package:pokemon/models/pokemon.dart';

enum PokemonsStatus { initial, loading, success, failure }

class PokemonsState extends Equatable {
  final PokemonsStatus status;
  final List<Pokemon> pokemons;
  final List<Pokemon> searchedPokemon;
  final Pokemon? selectedPokemon;

  const PokemonsState({
    this.status = PokemonsStatus.initial,
    this.pokemons = const [],
    this.searchedPokemon = const [],
    this.selectedPokemon,
  });

  PokemonsState copyWith({
    PokemonsStatus? status,
    List<Pokemon>? pokemons,
    List<Pokemon>? searchedPokemon,
    Pokemon? selectedPokemon,
  }) {
    return PokemonsState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      searchedPokemon: searchedPokemon ?? this.searchedPokemon,
      selectedPokemon: selectedPokemon ?? this.selectedPokemon,
    );
  }

  @override
  List<Object?> get props => [status, pokemons, searchedPokemon, selectedPokemon];
}
