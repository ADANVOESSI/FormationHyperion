import 'package:bloc/bloc.dart';
import 'package:pokemon/blocs/types_pokemons/types_pokemons_event.dart';
import 'package:pokemon/blocs/types_pokemons/types_pokemons_state.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';

class TypesPokemonsBloc extends Bloc<TypesPokemonsEvent, TypesPokemonsState> {
  TypesPokemonsBloc() : super(const TypesPokemonsState()) {
    on<LoadTypesPokemons>(_loadTypesPokemons);
    on<FilterChipSelected>(_filterTypesPokemons);
    on<AddPokemon>(_addPokemon);
  }

  Future<void> _loadTypesPokemons(LoadTypesPokemons event, Emitter<TypesPokemonsState> emit) async {
    try {
      final fetchedTypesPokemons = await pokeRepository.fetchPokemonTypes();
      emit(
        state.copyWith(
          status: TypesPokemonsStatus.success,
          typesPokemons: fetchedTypesPokemons,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TypesPokemonsStatus.failure));
    }
  }

  Future<void> _filterTypesPokemons(
    FilterChipSelected event,
    Emitter<TypesPokemonsState> emit,
  ) async {
    try {
      final updatedTypes = List<PokemonType>.from(state.typesPokemons);

      if (event.isSelected) {
        updatedTypes.add(event.pokemonType);
      } else {
        updatedTypes.remove(event.pokemonType);
      }

      emit(
        state.copyWith(
          selectedTypes: updatedTypes,
        ),
      );
    } catch (_) {}
  }

  Future<void> _addPokemon(
    AddPokemon event,
    Emitter<TypesPokemonsState> emit,
  ) async {
    try {
      await pokeRepository.addPokemon(
        name: event.name,
        imageUrl: event.imageUrl,
        types: event.types,
      );
      emit(state.copyWith());
    } catch (e) {}
  }
}
