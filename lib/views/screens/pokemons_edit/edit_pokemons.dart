import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/poke_theme.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/screens/pokemons_edit/type_pokemons.dart';

class EditPokemons extends StatefulWidget {
  const EditPokemons({
    required this.initialPokemon,
    required this.pokemon,
    super.key,
  });

  final Pokemon? initialPokemon;
  final Pokemon pokemon;

  @override
  State<EditPokemons> createState() => _EditPokemonsState();
}

class _EditPokemonsState extends State<EditPokemons> {
  List<PokemonType>? _allPokemonTypes;
  late Pokemon _pokemon;
  late TextEditingController _nameController;
  late TextEditingController _imageController;
  bool isLightTheme = true;

  @override
  void initState() {
    super.initState();
    _pokemon = widget.pokemon;

    _nameController = TextEditingController(text: _pokemon.name)..addListener(() => _pokemon.name = _nameController.text);
    _imageController = TextEditingController(text: _pokemon.imageUrl)..addListener(() => _pokemon.imageUrl = _imageController.text);

    pokeRepository.fetchPokemonTypes().then((value) => setState(() => _allPokemonTypes = value));
  }

  void _onTypeChanged(PokemonType type, bool selected) {
    if (selected) {
      _pokemon.types.add(type);
    } else {
      _pokemon.types.remove(type);
    }
    setState(() {});
  }

  // void _submitForm(BuildContext context) {
  //   final name = _nameController.text.trim();
  //   final imageUrl = _imageController.text.trim();
  //
  //   if (name.isNotEmpty && imageUrl.isNotEmpty && _pokemon.types.isNotEmpty) {
  //     // final updatedPokemon = Pokemon(
  //     //   id: _pokemon.id,
  //     //   name: name,
  //     //   imageUrl: imageUrl,
  //     //   types: _pokemon.types.toList(),
  //     // );
  //
  //     // pokeRepository.updatePokemon(updatedPokemon).then((_) {
  //     //   Navigator.of(context).pushReplacement(
  //     //     MaterialPageRoute(
  //     //       builder: (context) => PokemonsScreen(pokemonsBloc: pokemonsBloc,),
  //     //     ),
  //     //   );
  //     // }).catchError((error) {});
  //   } else {}
  // }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = isLightTheme ? PokeTheme.themeLight : PokeTheme.themeDark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: selectedTheme,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              iconSize: 28,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Update Pokemons',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              Switch(
                value: isLightTheme,
                onChanged: (value) {
                  setState(() {
                    isLightTheme = value;
                  });
                },
                activeTrackColor: Colors.black26,
                activeColor: Colors.white,
              ),
            ],
          ),
          body: Row(
            children: [
              Flexible(
                child: Hero(
                  tag: 'pokemon:${_pokemon.id}',
                  child: CachedNetworkImage(imageUrl: _pokemon.imageUrl),
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Flexible(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            decoration: const InputDecoration(label: Text('Nom')),
                            controller: _nameController,
                          ),
                          TextField(
                            decoration: const InputDecoration(label: Text('Image')),
                            controller: _imageController,
                          ),
                          if (_allPokemonTypes != null) ...[
                            const SizedBox(height: 20),
                            const Text('Types'),
                            Wrap(
                              spacing: 5,
                              children: _allPokemonTypes!
                                  .map(
                                    (type) => TypePokemon(
                                      type,
                                      initialValue: _pokemon.types.contains(type),
                                      onChanged: (value) => _onTypeChanged(type, value),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FilledButton.icon(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                label: const Text('Annuler'),
                              ),
                              FilledButton.icon(
                                icon: const Icon(Icons.save),
                                onPressed: () {
                                  // _submitForm(context);
                                },
                                label: const Text('Valider'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
