import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/constans/pokemons.dart';
import 'package:poke_app/widgets/app_scafold.dart';
import '../widgets/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  AppScaffoldState? _appScaffold;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appScaffold = context.findAncestorStateOfType<AppScaffoldState>();

    if (_appScaffold == appScaffold) return;

    _appScaffold?.removeFavoritesListener(_refreshFavorites);
    _appScaffold = appScaffold;
    _appScaffold?.addFavoritesListener(_refreshFavorites);
  }

  void _refreshFavorites() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _appScaffold?.removeFavoritesListener(_refreshFavorites);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = _appScaffold?.favoriteIds ?? <String>{};
    final favorites = pokemons
        .where((pokemon) => favoriteIds.contains(pokemon.id))
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
                    onFavoriteTap: () =>
                        _appScaffold?.toggleFavorite(pokemon.id),
                  ),
                );
              },
            ),
    );
  }
}
