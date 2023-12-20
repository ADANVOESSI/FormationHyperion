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
      print('$name, $imageUrl, $types');
    } catch (e) {
      throw Exception('Failed to add Pokemon to the database: $e');
    }
  }

  // Future<void> addPokemon(Pokemon pokemon) async {
  //   pokemon.id = (_pokemons?.length ?? 0) + 1;
  //   _pokemons
  //     ?..add(pokemon)
  //     ..sort((first, second) => first.name.toLowerCase().compareTo(second.name.toLowerCase()));
  // }

  Future<void> updatePokemon(Pokemon pokemon) async {
    print('La liste des pokemons : ${pokemon.types}');
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
      } else {
        print("Aucun Pokemon avec l'ID $index trouvé.");
      }
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
    } catch (e) {
      print('Erreur lors de la suppression des Pokémons : $e');
      throw Exception('Failed to delete Pokémons');
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
