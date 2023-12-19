import 'package:go_router/go_router.dart';
import 'package:pokemon/screens/pokemons/pokemons_screen.dart';
import 'package:pokemon/widgets/add_pokemons.dart';

final pokeRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return PokemonsScreen();
      },
      routes: [
        GoRoute(
          path: 'addPokemons',
          builder: (context, state) => AddPokemons(),
        ),
        // ... Autres routes
      ],
    ),
  ],
);
