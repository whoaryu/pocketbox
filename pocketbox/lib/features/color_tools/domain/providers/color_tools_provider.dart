import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbox/features/color_tools/domain/models/color_tools_model.dart';

class ColorToolsNotifier extends StateNotifier<ColorToolsState> {
  ColorToolsNotifier() : super(const ColorToolsState());

  void updateColor(Color color) {
    final hex = '#${color.value.toRadixString(16).substring(2)}';
    final rgb = 'rgb(${color.red}, ${color.green}, ${color.blue})';
    final hsl = colorToHSL(color);

    state = state.copyWith(
      selectedColor: color,
      hexColor: hex,
      rgbColor: rgb,
      hslColor: hsl,
      error: null,
    );
  }

  void updateImageColor(Color color) {
    final hex = '#${color.value.toRadixString(16).substring(2)}';
    final rgb = 'rgb(${color.red}, ${color.green}, ${color.blue})';
    final hsl = colorToHSL(color);

    state = state.copyWith(
      imageColor: color,
      hexColor: hex,
      rgbColor: rgb,
      hslColor: hsl,
      error: null,
    );
  }

  void setBlendColors(Color color1, Color color2) {
    final blended = Color.lerp(color1, color2, 0.5)!;
    final hex = '#${blended.value.toRadixString(16).substring(2)}';
    final rgb = 'rgb(${blended.red}, ${blended.green}, ${blended.blue})';
    final hsl = colorToHSL(blended);

    state = state.copyWith(
      color1: color1,
      color2: color2,
      blendedColor: blended,
      hexColor: hex,
      rgbColor: rgb,
      hslColor: hsl,
      error: null,
    );
  }

  String colorToHSL(Color color) {
    final hsl = HSLColor.fromColor(color);
    return 'hsl(${hsl.hue.round()}, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%)';
  }
}

final colorToolsProvider = StateNotifierProvider<ColorToolsNotifier, ColorToolsState>((ref) {
  return ColorToolsNotifier();
}); 