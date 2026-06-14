import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Section {
  const _Section(this.title, this.subtitle, this.icon, this.route, this.color);
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;
}

const _sections = <_Section>[
  _Section('Photos', '5000 images in a grid', Icons.photo_library_rounded,
      '/photos', Color(0xFF3D5AFE)),
  _Section('Albums', '100 albums of photos', Icons.collections_rounded,
      '/albums', Color(0xFF00897B)),
  _Section('Posts', '100 posts with comments', Icons.article_rounded, '/posts',
      Color(0xFFE65100)),
  _Section('Users', '10 user profiles', Icons.people_alt_rounded, '/users',
      Color(0xFF6A1B9A)),
  _Section('Comments', '500 comments', Icons.mode_comment_rounded, '/comments',
      Color(0xFFC2185B)),
  _Section('Todos', '200 tasks checklist', Icons.checklist_rounded, '/todos',
      Color(0xFF2E7D32)),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('API Demo'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _SectionCard(section: _sections[index]),
                childCount: _sections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});
  final _Section section;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go(section.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: section.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(section.icon, color: section.color, size: 28),
              ),
              const Spacer(),
              Text(
                section.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                section.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
