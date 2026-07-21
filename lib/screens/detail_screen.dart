import 'package:flutter/material.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_stat.dart';
import '../services/pokemon_service.dart';
import '../widgets/error_view.dart';
import '../widgets/type_chip.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _service = PokemonService();
  late Future<PokemonDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _service.fetchPokemonDetail(widget.id); // fired ONCE
  }

  void _retry() {
    setState(() {
      _detailFuture = _service.fetchPokemonDetail(
        widget.id,
      ); // a brand new Future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<PokemonDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // 1. LOADING — the Future is still incomplete
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ERROR — the Future completed with an exception
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error, onRetry: _retry);
          }

          // 3. SUCCESS — the detail is ready
          return _DetailView(detail: snapshot.data!);
        },
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  final PokemonDetail detail;

  const _DetailView({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Image.network(
            detail.imageUrl,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.catching_pokemon, size: 120);
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          detail.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [for (final type in detail.types) TypeChip(type: type)],
        ),
        const SizedBox(height: 24),
        for (final stat in detail.stats) _StatRow(stat: stat),
        const SizedBox(height: 24),
        Text('Habilidades', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final ability in detail.abilities) Text('• $ability'),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final PokemonStat stat;

  const _StatRow({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(stat.name)),
          Expanded(
            child: LinearProgressIndicator(
              value: stat.value / 255, // 255 = highest base stat in Pokémon
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 8),
          Text('${stat.value}'),
        ],
      ),
    );
  }
}
