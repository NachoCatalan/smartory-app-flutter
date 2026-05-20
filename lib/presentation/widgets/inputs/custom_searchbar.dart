import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchBarNode,
    required this.searchBarController,
    required this.searchCallback,
  });

  final FocusNode searchBarNode;
  final void Function(String value) searchCallback;
  final TextEditingController searchBarController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: searchBarNode,
      controller: searchBarController,
      onChanged: (value) {
        searchCallback(value);
      },
      onFieldSubmitted: (value) {
        searchCallback(value);
      },
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'Buscar...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: UnderlineInputBorder(),
        filled: true,
        fillColor: Colors.white70,
      ),
    );
  }
}
