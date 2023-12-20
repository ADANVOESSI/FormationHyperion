import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/theme_cubit.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_bloc.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_events.dart';
import 'package:pokemon/views/screens/pokemons_edit/data_cubit.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_bloc.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_event.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_state.dart';

class AddEditPokemonWidget extends StatelessWidget {
  final String? initialName;
  final String? initialImageUrl;
  final List<String>? initialTypes;

  AddEditPokemonWidget({
    super.key,
    this.initialName,
    this.initialImageUrl,
    this.initialTypes,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  late Pokemon _pokemon;

  void _submitForm(BuildContext context, List<PokemonType> selectedTypes) {
    final name = _nameController.text;
    final imageUrl = _imageUrlController.text;
    if (name.isNotEmpty && imageUrl.isNotEmpty && selectedTypes.isNotEmpty) {
      context.read<PokemonsBloc>().add(
            AddPokemon(
              name: name,
              imageUrl: imageUrl,
              types: selectedTypes,
            ),
          );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: initialName ?? '');
    TextEditingController imageUrlController = TextEditingController(text: initialImageUrl ?? '');
    TextEditingController typesController = TextEditingController(text: initialTypes != null ? initialTypes!.join(', ') : '');

    return BlocProvider<TypesPokemonsBloc>(
      create: (context) => TypesPokemonsBloc()..add(LoadTypesPokemons()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(initialName != null ? 'Edit Pokemon' : 'Add Pokemons', style: const TextStyle(fontSize: 22, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
          actions: <Widget>[
            Switch(
              value: context.watch<ThemeCubit>().state == ThemeModePokemon.light,
              onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              activeTrackColor: Colors.black26,
              activeColor: Colors.white,
            ),
          ],
        ),
        body: initialName != null
            ? Row(
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
                              Form(child: BlocBuilder<TypesPokemonsBloc, TypesPokemonsState>(builder: (context, state) {
                                if (state.status == TypesPokemonsStatus.loading) {
                                  return const CircularProgressIndicator();
                                } else if (state.status == TypesPokemonsStatus.success) {
                                  return Column(children: [
                                    TextField(
                                      decoration: const InputDecoration(label: Text('Nom')),
                                      controller: _nameController,
                                    ),
                                    const TextField(
                                      decoration: InputDecoration(label: Text('Image')),
                                      // controller: _imageController,
                                    ),
                                    const Text('Types'),
                                    Wrap(
                                      spacing: 5,
                                      children: state.typesPokemons.map((pokemonType) {
                                        return FilterChip(
                                          onSelected: (bool selected) {
                                            context.read<TypesPokemonsBloc>().add(
                                                  FilterTypesSelected(
                                                    pokemonType: pokemonType,
                                                    isSelected: selected,
                                                  ),
                                                );
                                          },
                                          selected: state.selectedTypes?.contains(pokemonType) ?? false,
                                          label: Text(pokemonType.name),
                                          avatar: CachedNetworkImage(imageUrl: pokemonType.imageUrl),
                                        );
                                      }).toList(),
                                    ),
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
                                  ]);
                                } else if (state.status == TypesPokemonsStatus.failure) {
                                  return const Text('Erreur lors du chargement des données !!');
                                } else {
                                  return const SizedBox();
                                }
                              }))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(100, 50, 100, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pokemon',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Form(
                          child: BlocBuilder<TypesPokemonsBloc, TypesPokemonsState>(
                            builder: (context, state) {
                              if (state.status == TypesPokemonsStatus.loading) {
                                return const CircularProgressIndicator();
                              } else if (state.status == TypesPokemonsStatus.success) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      decoration: const InputDecoration(labelText: 'Nom'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer un nom';
                                        }
                                        return null;
                                      },
                                      controller: _nameController,
                                      onChanged: (value) {
                                        context.read<DataCubit>().updateName(value);
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      decoration: const InputDecoration(labelText: "URL de l'image"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Veuillez entrer une URL d'image valide";
                                        }
                                        return null;
                                      },
                                      controller: _imageUrlController,
                                      onChanged: (value) {
                                        context.read<DataCubit>().updateImageUrl(value);
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const Text('Types'),
                                    Wrap(
                                      spacing: 5,
                                      children: state.typesPokemons.map((pokemonType) {
                                        return FilterChip(
                                          onSelected: (bool selected) {
                                            context.read<TypesPokemonsBloc>().add(
                                                  FilterTypesSelected(
                                                    pokemonType: pokemonType,
                                                    isSelected: selected,
                                                  ),
                                                );
                                          },
                                          selected: state.selectedTypes?.contains(pokemonType) ?? false,
                                          label: Text(pokemonType.name),
                                          avatar: CachedNetworkImage(imageUrl: pokemonType.imageUrl),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        _submitForm(context, state.selectedTypes ?? []);
                                      },
                                      child: const Text(
                                        'Ajouter',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (state.status == TypesPokemonsStatus.failure) {
                                return const Text('Erreur lors du chargement des données !!');
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
// Padding(
//   padding: const EdgeInsets.all(16),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       TextFormField(
//         controller: nameController,
//         decoration: const InputDecoration(labelText: 'Name'),
//       ),
//       const SizedBox(height: 16),
//       TextFormField(
//         controller: imageUrlController,
//         decoration: const InputDecoration(labelText: 'Image URL'),
//       ),
//       const SizedBox(height: 16),
//       TextFormField(
//         controller: typesController,
//         decoration: const InputDecoration(labelText: 'Types (comma-separated)'),
//       ),
//       const SizedBox(height: 32),
//       ElevatedButton(
//         onPressed: () {
//           String name = nameController.text;
//           String imageUrl = imageUrlController.text;
//           List<String> types = typesController.text.split(',').map((e) => e.trim()).toList();
//
//           print('Name: $name');
//           print('Image URL: $imageUrl');
//           print('Types: $types');
//         },
//         child: Text(initialName != null ? 'Save Changes' : 'Add Pokemon'),
//       ),
//     ],
//   ),
// ),
