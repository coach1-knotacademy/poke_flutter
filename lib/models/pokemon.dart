class Pokemon {
  final String id;
  final String name;
  final String type;
  final String imageUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  factory Pokemon.fromListItem(Map<String, dynamic> json) {
    // url: https://pokeapi.co/api/v2/pokemon/25/ → id = '25'
    final segments = Uri.parse(json['url'] as String).pathSegments;
    final id = segments[segments.length - 2];
    final name = json['name'] as String;

    return Pokemon(
      id: id,
      name: name[0].toUpperCase() + name.substring(1),
      type: '', // the list endpoint has no types — the detail endpoint does
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }
}
