import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorToolsState {
  final Color selectedColor;
  final String hexColor;
  final String rgbColor;
  final String hslColor;

  ColorToolsState({
    required this.selectedColor,
    required this.hexColor,
    required this.rgbColor,
    required this.hslColor,
  });

  ColorToolsState copyWith({
    Color? selectedColor,
    String? hexColor,
    String? rgbColor,
    String? hslColor,
  }) {
    return ColorToolsState(
      selectedColor: selectedColor ?? this.selectedColor,
      hexColor: hexColor ?? this.hexColor,
      rgbColor: rgbColor ?? this.rgbColor,
      hslColor: hslColor ?? this.hslColor,
    );
  }
}

class ColorToolsNotifier extends StateNotifier<ColorToolsState> {
  ColorToolsNotifier()
      : super(
          ColorToolsState(
            selectedColor: Colors.blue,
            hexColor: '#0000FF',
            rgbColor: 'rgb(0, 0, 255)',
            hslColor: 'hsl(240, 100%, 50%)',
          ),
        );

  void setColor(Color color) {
    final hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    final rgb = 'rgb(${color.red}, ${color.green}, ${color.blue})';
    final hsl = HSLColor.fromColor(color);
    final hslString =
        'hsl(${hsl.hue.round()}, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%)';

    state = state.copyWith(
      selectedColor: color,
      hexColor: hex,
      rgbColor: rgb,
      hslColor: hslString,
    );
  }
}

final colorToolsProvider =
    StateNotifierProvider<ColorToolsNotifier, ColorToolsState>((ref) {
  return ColorToolsNotifier();
}); 