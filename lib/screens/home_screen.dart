import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/constans/pokemons.dart';
import 'package:poke_app/widgets/app_scafold.dart';
import 'package:poke_app/widgets/pokemon_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String? _searchError; // null = no error
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
    final favoriteIds = _appScaffold?.favoriteIds ?? <String>{};
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
                          isFavorite: favoriteIds.contains(pokemon.id),
                          onFavoriteTap: () =>
                              _appScaffold?.toggleFavorite(pokemon.id),
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
