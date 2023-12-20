import 'package:bloc/bloc.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_event.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_state.dart';

class TypesPokemonsBloc extends Bloc<TypesPokemonsEvent, TypesPokemonsState> {
  TypesPokemonsBloc() : super(const TypesPokemonsState()) {
    on<LoadTypesPokemons>(_loadTypesPokemons);
    on<FilterTypesSelected>(_filterTypesPokemons);
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
    FilterTypesSelected event,
    Emitter<TypesPokemonsState> emit,
  ) async {
    try {
      final updatedTypes = List<PokemonType>.from(state.selectedTypes ?? []);

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
}
