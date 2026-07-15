import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/constans/pokemons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> _favoriteIds = {};
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // same pattern as HomeScreen
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = (_prefs.getStringList('favorites') ?? []).toSet();
    });
  }

  Future<void> _toggleFavorite(String id) async {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    await _prefs.setStringList('favorites', _favoriteIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final favorites = pokemons
        .where((p) => _favoriteIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favorites.isEmpty
          ? const Center(child: Text('Todavía no tienes favoritos :('))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, index) {
                final pokemon = favorites[index];
                return GestureDetector(
                  onTap: () =>
                      context.push('/pokemon/${pokemon.id}', extra: pokemon),
                  child: PokemonCard(
                    pokemon: pokemon,
                    isFavorite: true,
                    onFavoriteTap: () => _toggleFavorite(pokemon.id),
                  ),
                );
              },
            ),
    );
  }
}
