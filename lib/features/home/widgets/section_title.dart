import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool showViewAll;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
    this.showViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (showViewAll && onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }
} 