import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

const _pokemons = [
  Pokemon(
    id: '25',
    name: 'Pikachu',
    type: 'Eléctrico',
    imagenUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
  ),
  Pokemon(
    id: '4',
    name: 'Charmander',
    type: 'Fuego',
    imagenUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png',
  ),
  Pokemon(
    id: '7',
    name: 'Squirtle',
    type: 'Agua',
    imagenUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png',
  ),
  Pokemon(
    id: '1',
    name: 'Bulbasaur',
    type: 'Planta',
    imagenUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pokemonsFilter = [];

  @override
  void initState() {
    super.initState();
    pokemonsFilter = _pokemons
        .where((pokemon) => pokemon.name.toLowerCase().contains('pika'))
        .toList();
  }

  void filterPokemos(String value) {
    pokemonsFilter = _pokemons
        .where((pokemon) => pokemon.name.toLowerCase().contains(value))
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Busca un Pokémon...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => filterPokemos(value),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: pokemonsFilter.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, index) {
                final pokemon = pokemonsFilter[index];
                return GestureDetector(
                  onTap: () =>
                      context.push('/pokemon/${pokemon.id}', extra: pokemon),
                  child: PokemonCard(pokemon: pokemon),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
