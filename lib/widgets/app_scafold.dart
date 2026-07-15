import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffold({super.key, required this.navigationShell});

  @override
  State<AppScaffold> createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
  Set<String> _favoriteIds = {};
  SharedPreferences? _preferences;
  final List<VoidCallback> _favoritesListeners = [];

  Set<String> get favoriteIds => _favoriteIds;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final preferences = await SharedPreferences.getInstance();

    if (!mounted) return;

    _preferences = preferences;
    setState(() {
      _favoriteIds = (preferences.getStringList('favorites') ?? []).toSet();
    });
    _notifyFavoritesListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final preferences = _preferences ?? await SharedPreferences.getInstance();

    if (!mounted) return;

    _preferences = preferences;
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    _notifyFavoritesListeners();

    await preferences.setStringList('favorites', _favoriteIds.toList());
  }

  void addFavoritesListener(VoidCallback listener) {
    _favoritesListeners.add(listener);
  }

  void removeFavoritesListener(VoidCallback listener) {
    _favoritesListeners.remove(listener);
  }

  void _notifyFavoritesListeners() {
    for (final listener in List<VoidCallback>.of(_favoritesListeners)) {
      listener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokédex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
