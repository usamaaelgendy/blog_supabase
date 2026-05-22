import 'package:blog_app/core/constants/post_categories.dart';
import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;

  const CategoryFilterBar({super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final c in kPostCategories)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(c.label),
                selected: selected == c.value,
                onSelected: (isSelected) => onSelected(isSelected ? c.value : null),
              ),
            ),
        ],
      ),
    );
  }
}