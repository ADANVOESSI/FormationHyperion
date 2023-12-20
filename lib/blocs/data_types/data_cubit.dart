import 'package:bloc/bloc.dart';

import 'data_types_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit()
      : super(DataState(
          name: '',
          imageUrl: '',
        ));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateImageUrl(String imageUrl) {
    emit(state.copyWith(imageUrl: imageUrl));
  }
}