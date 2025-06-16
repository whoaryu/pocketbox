import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/color_tools/domain/providers/color_tools_provider.dart';
import 'package:pocketbox/features/color_tools/presentation/widgets/color_picker_tab.dart';

class ColorToolsScreen extends ConsumerWidget {
  const ColorToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Color Tools'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Color Picker'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ColorPickerTab(),
          ],
        ),
      ),
    );
  }
} 