import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pocketbox/features/image_tools/domain/models/image_tools_model.dart';

class ImageToolsNotifier extends StateNotifier<ImageToolsState> {
  ImageToolsNotifier() : super(const ImageToolsState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final image = img.decodeImage(await file.readAsBytes());
        if (image != null) {
          state = state.copyWith(
            imageFile: file,
            width: image.width,
            height: image.height,
            error: null,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  Future<void> resizeImage(int newWidth, int newHeight) async {
    if (state.imageFile == null) return;

    try {
      state = state.copyWith(isLoading: true);
      final bytes = await state.imageFile!.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        final resized = img.copyResize(
          image,
          width: newWidth,
          height: newHeight,
        );
        final resizedBytes = img.encodeJpg(resized);
        final tempFile = File('${state.imageFile!.path}_resized.jpg');
        await tempFile.writeAsBytes(resizedBytes);
        state = state.copyWith(
          imageFile: tempFile,
          width: newWidth,
          height: newHeight,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to resize image: $e',
      );
    }
  }

  Future<void> compressImage(double quality) async {
    if (state.imageFile == null) return;

    try {
      state = state.copyWith(isLoading: true);
      final bytes = await state.imageFile!.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        final compressed = img.encodeJpg(image, quality: quality.toInt());
        final tempFile = File('${state.imageFile!.path}_compressed.jpg');
        await tempFile.writeAsBytes(compressed);
        state = state.copyWith(
          imageFile: tempFile,
          quality: quality,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to compress image: $e',
      );
    }
  }

  void clearImage() {
    state = const ImageToolsState();
  }
}

final imageToolsProvider = StateNotifierProvider<ImageToolsNotifier, ImageToolsState>((ref) {
  return ImageToolsNotifier();
}); 