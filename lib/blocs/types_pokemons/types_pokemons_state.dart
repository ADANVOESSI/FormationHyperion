import 'package:equatable/equatable.dart';

import '../../models/pokemon_type.dart';

enum TypesPokemonsStatus { initial, loading, success, failure }

class TypesPokemonsState extends Equatable {
  final TypesPokemonsStatus status;
  final List<PokemonType> typesPokemons;
  final List<PokemonType>? selectedTypes;

  const TypesPokemonsState({
    this.status = TypesPokemonsStatus.initial,
    this.typesPokemons = const [],
    this.selectedTypes,
  });

  TypesPokemonsState copyWith({
    TypesPokemonsStatus? status,
    List<PokemonType>? typesPokemons,
    List<PokemonType>? selectedTypes,
  }) {
    return TypesPokemonsState(
      status: status ?? this.status,
      typesPokemons: typesPokemons ?? this.typesPokemons,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }

  @override
  List<Object?> get props => [status, typesPokemons, selectedTypes];
}
