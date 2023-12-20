import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_events.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_state.dart';

class PokemonsBloc extends Bloc<PokemonsEvent, PokemonsState> {
  PokemonsBloc() : super(const PokemonsState()) {
    on<SearchPokemon>(_searchPokemon);
    on<PokemonsDeleted>(_deletedPokemon);
    on<LoadPokemons>(_loadPokemons);
    on<DeleteAllPokemons>(_deleteAllPokemons);
    on<PokemonSelected>(_pokemonSelected);
    on<AddPokemon>(_addPokemon);
  }

  Future<void> _loadPokemons(LoadPokemons event, Emitter<PokemonsState> emit) async {
    try {
      final fetchedPokemons = await pokeRepository.fetchPokemons();
      emit(
        state.copyWith(
          status: PokemonsStatus.success,
          pokemons: fetchedPokemons,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: PokemonsStatus.failure));
    }
  }

  Future<void> _deletedPokemon(PokemonsDeleted event, Emitter<PokemonsState> emit) async {
    try {
      await pokeRepository.deletePokemon(event.index);
      // emit(state.copyWith(/* ... */)); // Émettez l'état mis à jour si nécessaire
    } catch (e) {
      log("L'erreur est $e");
    }
  }

  Future<void> _deleteAllPokemons(DeleteAllPokemons event, Emitter<PokemonsState> emit) async {
    try {
      await pokeRepository.deleteAllPokemons();
      emit(
        state.copyWith(
          status: PokemonsStatus.success,
          pokemons: [],
        ),
      );
    } catch (e) {
      log("L'erreur est $e");
    }
  }

  void _pokemonSelected(PokemonSelected event, Emitter<PokemonsState> emit) {
    emit(state.copyWith(selectedPokemon: event.selectedPokemon));
  }

  void _searchPokemon(SearchPokemon event, Emitter<PokemonsState> emit) {
    final searchText = event.searchText.toLowerCase();

    final searchedPokemon = state.pokemons.where((poke) => poke.name.toLowerCase().contains(searchText)).toList();

    emit(
      state.copyWith(
        searchedPokemon: searchedPokemon,
      ),
    );
  }

  Future<void> _addPokemon(
    AddPokemon event,
    Emitter<PokemonsState> emit,
  ) async {
    try {
      await pokeRepository.addPokemon(
        name: event.name,
        imageUrl: event.imageUrl,
        types: event.types,
      );
      emit(state.copyWith());
    } catch (e) {
      log('Failed to load types pokemons $e', stackTrace: StackTrace.current);
    }
  }
}
