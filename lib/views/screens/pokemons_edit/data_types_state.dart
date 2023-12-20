class DataState {
  final String name;
  final String imageUrl;

  DataState({required this.name, required this.imageUrl});

  DataState copyWith({String? name, String? imageUrl}) {
    return DataState(name: name ?? this.name, imageUrl: imageUrl ?? this.imageUrl);
  }
}
