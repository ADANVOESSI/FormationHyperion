import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/poke_theme.dart';

enum ThemeModePokemon { light, dark }

extension ThemeModePokemonExt on ThemeModePokemon {
  ThemeData get themeData {
    if (this == ThemeModePokemon.light) return PokeTheme.themeLight;
    return PokeTheme.themeDark;
  }
}

class ThemeCubit extends Cubit<ThemeModePokemon> {
  ThemeCubit() : super(ThemeModePokemon.light);

  void toggleTheme() {
    if (state == ThemeModePokemon.light) {
      emit(ThemeModePokemon.dark);
    } else {
      emit(ThemeModePokemon.light);
    }
  }
}
