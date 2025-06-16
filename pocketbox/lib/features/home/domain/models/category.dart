import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;
  final String route;

  const Category({
    required this.title,
    required this.icon,
    required this.route,
  });

  static const categories = [
    Category(
      title: 'Text Tools',
      icon: Icons.text_fields,
      route: '/text-tools',
    ),
    Category(
      title: 'Converters',
      icon: Icons.swap_horiz,
      route: '/converters',
    ),
    Category(
      title: 'Generators',
      icon: Icons.auto_awesome,
      route: '/generators',
    ),
    Category(
      title: 'Dev Tools',
      icon: Icons.code,
      route: '/dev-tools',
    ),
    Category(
      title: 'Randomizer',
      icon: Icons.shuffle,
      route: '/randomizer',
    ),
    Category(
      title: 'System Utilities',
      icon: Icons.settings,
      route: '/system-utils',
    ),
  ];
} 