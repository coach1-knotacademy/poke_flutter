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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: _pokemons.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final pokemon = _pokemons[index];
          return GestureDetector(
            onTap: () => context.push('/pokemon/${pokemon.id}', extra: pokemon),
            child: PokemonCard(pokemon: pokemon),
          );
        },
      ),
    );
  }
}
