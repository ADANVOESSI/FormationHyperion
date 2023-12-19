import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/models/pokemon.dart';

class PokeApi {
  PokeApi();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Pokemon>> fetchPokemons({int chunkSize = 50}) async {
    final response = await http.get(Uri.parse('https://pokebuildapi.fr/api/v1/pokemon/limit/$chunkSize'));
    if (response.statusCode == 200) {
      final jsonArray = jsonDecode(response.body) as List? ?? [];
      final pokemons = jsonArray.cast<Map<String, dynamic>>().map(Pokemon.fromJson).toList();
      return pokemons;
    } else {
      throw Exception('Failed to fetch Pokemon');
    }
  }

  Future<void> savePokemonsToFirestore() async {
    try {
      final pokemons = await fetchPokemons();
      final CollectionReference pokemonCollection = FirebaseFirestore.instance.collection('pokemons');

      await Future.forEach(pokemons, (Pokemon pokemon) async {
        await pokemonCollection.add(pokemon.toJson());
      });
    } catch (e) {
      throw Exception('Failed to save Pokemon to Firestore: $e');
    }
  }

  Future<List<Pokemon>> fetchPokemonsOnFirebase() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore.collection('pokemons').get();
      final pokemons = querySnapshot.docs.map((doc) => Pokemon.fromJson(doc.data()! as Map<String, dynamic>, dataSource: 'firestore')).toList();
      if (pokemons.isEmpty) {
        await savePokemonsToFirestore();
        return await fetchPokemons();
      } else {
        return pokemons;
      }
    } catch (e) {
      throw Exception('Failed to fetch Pokemon');
    }
  }
}

PokeApi pokeApi = PokeApi();
