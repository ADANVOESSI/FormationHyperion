import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/api/poke_api.dart';
import 'package:pokemon/utils/extension/iterable_extension.dart';

class PokeRepository {
  List<Pokemon>? _pokemons;

  PokeRepository._();

  Future<List<Pokemon>> fetchPokemons() async {
    _pokemons = await pokeApi.fetchPokemonsOnFirebase();
    if (_pokemons != null) {
      _pokemons!.sort((a, b) => a.name.compareTo(b.name));
      return _pokemons!;
    }
    return [];
  }

  Future<List<PokemonType>> fetchPokemonTypes() async {
    final pokemons = await fetchPokemons();
    final allTypes = pokemons.expand((pokemon) => pokemon.types).toList().distinctBy((type) => type.name).toList(growable: false)..sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    return allTypes;
  }

  Future<void> addPokemon({
    required String name,
    required String imageUrl,
    required List<PokemonType> types,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('pokemons').add({
        'id': (_pokemons?.length ?? 0) + 1,
        'name': name,
        'imageUrl': imageUrl,
        'type': types,
      });
    } catch (e) {
      throw Exception('Failed to add Pokemon to the database: $e');
    }
  }

  Future<void> updatePokemon(Pokemon pokemon) async {
    try {
      await FirebaseFirestore.instance.collection('pokemons').doc(pokemon.id.toString()).update(pokemon.toJson());
    } catch (e) {
      throw Exception('Failed to update Pokemon: $e');
    }
  }

  Future<void> deletePokemon(int index) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pokemons').where('id', isEqualTo: index).get();

      final documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        await documents.first.reference.delete();
      } else {}
    } catch (e) {
      throw Exception('Failed to delete Pokemon: $e');
    }
  }

  Future<void> deleteAllPokemons() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pokemons').get();

      final documents = querySnapshot.docs;
      await Future.forEach(documents, (doc) async {
        await doc.reference.delete();
      });
    } catch (error, stacktrace) {
      throw Exception('Failed to delete Pokémons\n$error\nstacktrace: $stacktrace');
    }
  }
}

PokeRepository pokeRepository = PokeRepository._();

// Future<List<PokemonType>>? fetchPokemonTypes() async {
//   final pokemons = await fetchPokemons();
//
//   final types = pokemons
//       .expand((pokemon) => pokemon.types)
//       .distinctBy((e) => e.name)
//       .toList(growable: false)
//     ..sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
//   return types;
// }
