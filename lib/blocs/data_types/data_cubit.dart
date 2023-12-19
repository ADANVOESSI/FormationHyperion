import 'package:bloc/bloc.dart';

import '../../models/pokemon_type.dart';
import 'data_types_state.dart';

class DataCubit extends Cubit<ThemeDataState> {
  DataCubit()
      : super(ThemeDataState(
          name: '',
          imageUrl: '',
          types: [],
        ));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateImageUrl(String imageUrl) {
    emit(state.copyWith(imageUrl: imageUrl));
  }

  void updateTypes(List<PokemonType> types) {
    emit(state.copyWith(types: types));
  }
}
