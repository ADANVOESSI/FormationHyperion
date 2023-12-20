import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_type.dart';

class TypePokemon extends StatefulWidget {
  final PokemonType _type;
  final bool initialValue;
  final void Function(bool) onChanged;

  const TypePokemon(
    this._type, {
    required this.onChanged,
    this.initialValue = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TypePokemonState();
}

class _TypePokemonState extends State<TypePokemon> {
  bool _isSelected = false;

  void _onChange(bool value) {
    widget.onChanged(value);
    setState(() => _isSelected = value);
  }

  @override
  void initState() {
    _isSelected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      onSelected: _onChange,
      selected: _isSelected,
      label: Text(widget._type.name),
      avatar: CachedNetworkImage(imageUrl: widget._type.imageUrl),
    );
  }
}
