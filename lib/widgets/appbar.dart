import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchCancel;
  final ValueChanged<String> onSearchQueryChanged;
  final VoidCallback onSearchStart;
  final Future<void> Function() onDateSelected;

  const CustomAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchCancel,
    required this.onSearchQueryChanged,
    required this.onSearchStart,
    required this.onDateSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white, // Fundo branco
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Bordas ovais
                  borderSide: BorderSide.none, // Remove borda padrão
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 15), // Ajuste no padding
                isDense: true, // Reduz a altura
                constraints: BoxConstraints(
                  minHeight: 50, // Define uma altura mínima menor
                ),
              ),
              onChanged: onSearchQueryChanged,
            )
          : const Text(
              'Rei das Promoções',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
      actions: [
        if (isSearching)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onSearchCancel,
          )
        else
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: onSearchStart,
          ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: onDateSelected,
        ),
      ],
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}
