import 'dart:io';
import 'package:flutter/material.dart';

class ImageToolsState {
  final File? imageFile;
  final int? width;
  final int? height;
  final double quality;
  final bool isLoading;
  final String? error;

  const ImageToolsState({
    this.imageFile,
    this.width,
    this.height,
    this.quality = 100,
    this.isLoading = false,
    this.error,
  });

  ImageToolsState copyWith({
    File? imageFile,
    int? width,
    int? height,
    double? quality,
    bool? isLoading,
    String? error,
  }) {
    return ImageToolsState(
      imageFile: imageFile ?? this.imageFile,
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
} 