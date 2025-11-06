import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/core/providers/theme_provider.dart';
import 'package:pocketbox/core/theme/app_theme.dart';
import 'package:pocketbox/features/converters/presentation/screens/base64_converter_screen.dart';
import 'package:pocketbox/features/dev_tools/presentation/screens/json_formatter_screen.dart';
import 'package:pocketbox/features/generators/presentation/screens/qr_code_generator_screen.dart';
import 'package:pocketbox/features/home/presentation/screens/home_screen.dart';
import 'package:pocketbox/screens/randomizer_tools_screen.dart';
import 'package:pocketbox/screens/general_tools_screen.dart';
import 'package:pocketbox/features/system_utils/presentation/screens/clipboard_manager_screen.dart';
import 'package:pocketbox/features/text_tools/presentation/screens/text_tools_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PocketBoxApp(),
    ),
  );
}

class PocketBoxApp extends ConsumerWidget {
  const PocketBoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'PocketBox',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/text-tools': (context) => const TextToolsScreen(),
        '/converters': (context) => const Base64ConverterScreen(),
        '/generators': (context) => const QRCodeGeneratorScreen(),
        '/dev-tools': (context) => const JSONFormatterScreen(),
        '/randomizer': (context) => const RandomizerToolsScreen(),
        '/general-tools': (context) => const GeneralToolsScreen(),
        '/system-utils': (context) => const ClipboardManagerScreen(),
      },
    );
  }
}
