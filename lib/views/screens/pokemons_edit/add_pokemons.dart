import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/theme_cubit.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_bloc.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_events.dart';
import 'package:pokemon/views/screens/pokemons_edit/data_cubit.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_bloc.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_event.dart';
import 'package:pokemon/views/screens/pokemons_edit/types_pokemons_state.dart';

class AddPokemons extends StatelessWidget {
  AddPokemons({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

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
    return BlocProvider<TypesPokemonsBloc>(
      create: (context) => TypesPokemonsBloc()..add(LoadTypesPokemons()),
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
            'Add Pokemons',
            style: TextStyle(fontSize: 22, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            Switch(
              value: context.watch<ThemeCubit>().state == ThemeModePokemon.light,
              onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              activeTrackColor: Colors.black26,
              activeColor: Colors.white,
            ),
          ],
        ),
        body: Center(
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
