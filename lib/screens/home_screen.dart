import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/constans/pokemons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String? _searchError; // null = no error
  Set<String> _favoriteIds = {};
  late final SharedPreferences _prefs; // single instance

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = (_prefs.getStringList('favorites') ?? []).toSet();
    });
  }

  Future<void> _toggleFavorite(String id) async {
    // Update UI immediately, then persist to disk.
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    await _prefs.setStringList('favorites', _favoriteIds.toList());
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _searchError = value.contains(RegExp(r'[0-9]'))
          ? 'El nombre solo lleva letras'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = pokemons
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Busca un Pokémon...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                errorText: _searchError,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Ningún Pokémon coincide'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (_, index) {
                      final pokemon = filtered[index];
                      return GestureDetector(
                        onTap: () => context.push(
                          '/pokemon/${pokemon.id}',
                          extra: pokemon,
                        ),
                        child: PokemonCard(
                          pokemon: pokemon,
                          isFavorite: _favoriteIds.contains(pokemon.id),
                          onFavoriteTap: () => _toggleFavorite(pokemon.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
