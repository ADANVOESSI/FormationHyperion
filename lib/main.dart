import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/blocs/pokemons/pokemons_bloc.dart';
import 'package:pokemon/blocs/pokemons/pokemons_events.dart';
import 'package:pokemon/blocs/theme_cubit.dart';
import 'package:pokemon/firebase_options.dart';
import 'package:pokemon/poke_app.dart';

import 'blocs/data_types/data_cubit.dart';
import 'blocs/types_pokemons/types_pokemons_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeCubit = ThemeCubit();
  final dataCubit = DataCubit();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PokemonsBloc>(
          create: (context) => PokemonsBloc()..add(LoadPokemons()),
        ),
        BlocProvider<TypesPokemonsBloc>(
          create: (context) => TypesPokemonsBloc(),
        ),
        BlocProvider<ThemeCubit>(create: (context) => themeCubit),
        BlocProvider<DataCubit>(create: (context) => dataCubit),
      ],
      child: const PokeApp(),
    ),
  );
}
