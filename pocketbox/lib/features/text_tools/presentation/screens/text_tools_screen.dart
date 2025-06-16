import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_analysis_provider.dart';
import 'package:pocketbox/features/text_tools/domain/providers/text_utils_provider.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/case_converter_tab.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/find_replace_tab.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/prefix_suffix_tab.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/repeat_text_tab.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/remove_spaces_tab.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/reverse_text_tab.dart';
import 'package:pocketbox/features/text_tools/presentation/widgets/word_counter_tab.dart';

class TextToolsScreen extends ConsumerStatefulWidget {
  const TextToolsScreen({super.key});

  @override
  ConsumerState<TextToolsScreen> createState() => _TextToolsScreenState();
}

class _TextToolsScreenState extends ConsumerState<TextToolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Tools'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Word Counter'),
            Tab(text: 'Case Converter'),
            Tab(text: 'Find & Replace'),
            Tab(text: 'Repeat Text'),
            Tab(text: 'Remove Spaces'),
            Tab(text: 'Prefix/Suffix'),
            Tab(text: 'Reverse Text'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          WordCounterTab(),
          CaseConverterTab(),
          FindReplaceTab(),
          RepeatTextTab(),
          RemoveSpacesTab(),
          PrefixSuffixTab(),
          ReverseTextTab(),
        ],
      ),
    );
  }
} 