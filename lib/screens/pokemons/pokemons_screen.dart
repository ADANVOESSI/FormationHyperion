import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/blocs/pokemons/pokemons_bloc.dart';
import 'package:pokemon/blocs/pokemons/pokemons_events.dart';
import 'package:pokemon/blocs/pokemons/pokemons_state.dart';
import 'package:pokemon/blocs/theme_cubit.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/screens/pokemons_edit/edit_pokemons.dart';

import '../../blocs/types_pokemons/types_pokemons_bloc.dart';
import '../../blocs/types_pokemons/types_pokemons_event.dart';
import '../../poke_routes.dart';
import 'details_pokemons.dart';

class PokemonsScreen extends StatelessWidget {
  PokemonsScreen({super.key});

  final List<Pokemon> searchedPokemon = [];
  final TextEditingController _searchController = TextEditingController();
  final bool _isSearching = false;

  void _editPokemon(BuildContext context, Pokemon? selectedPokemon) {
    if (selectedPokemon != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPokemons(
            initialPokemon: selectedPokemon,
            pokemon: selectedPokemon,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun Pokémon sélectionné'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          iconSize: 28,
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un Pokemon...',
                  hintStyle: TextStyle(),
                ),
                style: const TextStyle(),
                // onChanged: _searchPokemon,
                onChanged: (value) {
                  // pokemonsBloc.add(SearchPokemon(value));
                },
              )
            : const Text(
                'Pokemons',
                style: TextStyle(fontSize: 22, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
              ),
        actions: <Widget>[
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  iconSize: 28,
                  onPressed: () {
                    // setState(() {
                    //   _isSearching = false;
                    //   _searchController.clear();
                    // });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 28,
                  onPressed: () {
                    // setState(() {
                    //   _isSearching = true;
                    // });
                  },
                ),
          IconButton(
            iconSize: 28,
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
          IconButton(
              iconSize: 28,
              icon: const Icon(Icons.download),
              onPressed: () {
                context.read<PokemonsBloc>().add(LoadPokemons());
              }),
          IconButton(
            iconSize: 28,
            icon: const Icon(Icons.add),
            onPressed: () {
              pokeRoutes.go('/addPokemons');

              Future.delayed(Duration.zero, () {
                context.read<TypesPokemonsBloc>().add(LoadTypesPokemons());
              });
            },
          ),
          Switch(
            value: context.watch<ThemeCubit>().state == ThemeModePokemon.light,
            onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
            activeTrackColor: Colors.black26,
            activeColor: Colors.white,
          ),
        ],
      ),
      body: BlocBuilder<PokemonsBloc, PokemonsState>(
        builder: (context, state) {
          if (state.status == PokemonsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == PokemonsStatus.failure) {
            return const Center(child: Text('Erreur lors du chargement des Pokémon'));
          } else {
            return Row(
              children: [
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      body: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(
                                child: SizedBox(
                                  width: 35,
                                  height: 30,
                                  child: Icon(Icons.list, size: 30),
                                ),
                              ),
                              Tab(
                                child: SizedBox(
                                  width: 35,
                                  height: 25,
                                  child: Icon(Icons.dashboard, size: 30),
                                ),
                              ),
                            ],
                            labelColor: Colors.red,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ListView.builder(
                                  itemCount: _isSearching ? searchedPokemon.length : state.pokemons.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final currentPokemon = _isSearching ? searchedPokemon[index] : state.pokemons[index];
                                    return Visibility(
                                      visible: _isSearching && currentPokemon.name.toLowerCase() != _searchController.text.toLowerCase(),
                                      replacement: Dismissible(
                                        key: Key(currentPokemon.id.toString()),
                                        direction: DismissDirection.startToEnd,
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          color: Colors.red,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDismissed: (DismissDirection direction) {
                                          context.read<PokemonsBloc>().add(PokemonsDeleted(index: index));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Pokemon supprimé'),
                                              action: SnackBarAction(
                                                label: 'Annuler',
                                                onPressed: () {},
                                              ),
                                            ),
                                          );
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            context.read<PokemonsBloc>().add(PokemonSelected(currentPokemon));
                                          },
                                          child: Card(
                                            color: Colors.transparent,
                                            elevation: 0,
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 28,
                                                child: currentPokemon.imageUrl.isNotEmpty ? Image.network(currentPokemon.imageUrl) : const FlutterLogo(size: 24),
                                              ),
                                              title: Text(currentPokemon.name),
                                              subtitle: Text('Types: ${currentPokemon.types.map((type) => type.name).join(', ')}'),
                                              trailing: const Icon(Icons.favorite_border),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(),
                                    );
                                  },
                                ),
                                GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemCount: _isSearching ? searchedPokemon.length : state.pokemons.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final currentPokemon = _isSearching ? searchedPokemon[index] : state.pokemons[index];
                                    return Visibility(
                                      visible: _isSearching && currentPokemon.name.toLowerCase() != _searchController.text.toLowerCase(),
                                      replacement: Dismissible(
                                        key: Key(currentPokemon.id.toString()),
                                        direction: DismissDirection.startToEnd,
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          color: Colors.red,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDismissed: (DismissDirection direction) {
                                          context.read<PokemonsBloc>().add(PokemonsDeleted(index: index));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Pokemon supprimé'),
                                              action: SnackBarAction(
                                                label: 'Annuler',
                                                onPressed: () {
                                                  // Rétablir la suppression si nécessaire
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            context.read<PokemonsBloc>().add(PokemonSelected(currentPokemon));
                                          },
                                          child: Card(
                                            color: Colors.transparent,
                                            elevation: 0,
                                            child: GridTile(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 60,
                                                        child: currentPokemon.imageUrl.isNotEmpty
                                                            ? Image.network(
                                                                currentPokemon.imageUrl,
                                                                fit: BoxFit.cover,
                                                              )
                                                            : const FlutterLogo(size: 24),
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            currentPokemon.name,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 10),
                Expanded(
                  flex: 2,
                  child: Builder(builder: (context) {
                    return DetailPokemon(context.select((PokemonsBloc pokemonBloc) => pokemonBloc.state.selectedPokemon));
                  }),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editPokemon(context, context.read<PokemonsBloc>().state.selectedPokemon),
        label: const Text('Edit'),
        icon: const Icon(Icons.edit),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer tous les Pokémons ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                context.read<PokemonsBloc>().add(DeleteAllPokemons());
                Navigator.of(context).pop(true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
