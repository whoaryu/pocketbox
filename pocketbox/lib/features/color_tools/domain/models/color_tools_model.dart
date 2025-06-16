import 'package:flutter/material.dart';

class ColorToolsState {
  final Color selectedColor;
  final String hexColor;
  final String rgbColor;
  final String hslColor;
  final Color? imageColor;
  final Color? color1;
  final Color? color2;
  final Color? blendedColor;
  final bool isLoading;
  final String? error;

  const ColorToolsState({
    this.selectedColor = Colors.blue,
    this.hexColor = '#0000FF',
    this.rgbColor = 'rgb(0, 0, 255)',
    this.hslColor = 'hsl(240, 100%, 50%)',
    this.imageColor,
    this.color1,
    this.color2,
    this.blendedColor,
    this.isLoading = false,
    this.error,
  });

  ColorToolsState copyWith({
    Color? selectedColor,
    String? hexColor,
    String? rgbColor,
    String? hslColor,
    Color? imageColor,
    Color? color1,
    Color? color2,
    Color? blendedColor,
    bool? isLoading,
    String? error,
  }) {
    return ColorToolsState(
      selectedColor: selectedColor ?? this.selectedColor,
      hexColor: hexColor ?? this.hexColor,
      rgbColor: rgbColor ?? this.rgbColor,
      hslColor: hslColor ?? this.hslColor,
      imageColor: imageColor ?? this.imageColor,
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      blendedColor: blendedColor ?? this.blendedColor,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
} 