import 'package:flutter/material.dart';

enum PluginCategory {
  editor('Editor', Icons.edit, 'Editor enhancements and features'),
  utility('Utility', Icons.build, 'Tools and utilities'),
  experimental('Experimental', Icons.science, 'Beta features and experiments');

  final String displayName;
  final IconData icon;
  final String description;

  const PluginCategory(this.displayName, this.icon, this.description);
}

class PluginDefinition {
  final String id;
  final String name;
  final String? description;
  final IconData icon;
  final PluginCategory category;
  final String version;
  final String author;
  final List<String> dependencies;
  final List<String> conflictsWith;
  final Map<String, dynamic> defaultConfig;
  final bool requiresRestart;
  final bool enabledByDefault;
  final DateTime? lastUpdated;

  const PluginDefinition({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.category,
    this.version = '0.0.1',
    this.author = 'Gzip Explorer',
    this.dependencies = const [],
    this.conflictsWith = const [],
    this.defaultConfig = const {},
    this.requiresRestart = false,
    this.enabledByDefault = true,
    this.lastUpdated,
  });

}
