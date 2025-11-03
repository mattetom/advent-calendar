import 'package:flutter/material.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({required this.day, super.key});

  static const String routePath = 'content';

  final int day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = _contentForDay(day);
    return Scaffold(
      appBar: AppBar(
        title: Text('Giorno $day'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(content.icon, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                content.title,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                content.description,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _DailyContent _contentForDay(int day) {
    final categories = <_DailyContent>[
      const _DailyContent(
        icon: Icons.movie,
        title: 'Video speciale',
        description: 'Guarda un breve video di auguri natalizi.',
      ),
      const _DailyContent(
        icon: Icons.image,
        title: 'Immagine festiva',
        description: 'Scopri un\'illustrazione invernale da condividere.',
      ),
      const _DailyContent(
        icon: Icons.videogame_asset,
        title: 'Minigioco',
        description: 'Completa una piccola sfida per ottenere un premio.',
      ),
      const _DailyContent(
        icon: Icons.music_note,
        title: 'Playlist',
        description: 'Ascolta una selezione di brani natalizi.',
      ),
    ];
    return categories[(day - 1) % categories.length];
  }
}

class _DailyContent {
  const _DailyContent({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
