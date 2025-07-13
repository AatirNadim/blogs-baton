import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/image_processing_service.dart';

// State class
class ImageState {
  final bool isLoading;
  final Uint8List? originalImage;
  final Uint8List? processedImage;
  final String? errorMessage;

  ImageState({
    this.isLoading = false,
    this.originalImage,
    this.processedImage,
    this.errorMessage,
  });

  ImageState copyWith({
    bool? isLoading,
    Uint8List? originalImage,
    Uint8List? processedImage,
    String? errorMessage,
  }) {
    return ImageState(
      isLoading: isLoading ?? this.isLoading,
      originalImage: originalImage ?? this.originalImage,
      processedImage: processedImage ?? this.processedImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// StateNotifier
class ImageNotifier extends StateNotifier<ImageState> {
  final ImageProcessingService _service;
  ImageNotifier(this._service) : super(ImageState());

  Future<void> pickImage() async {
    if (await Permission.photos.request().isGranted) {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        state = state.copyWith(originalImage: bytes, processedImage: null, errorMessage: null);
      }
    } else {
      state = state.copyWith(errorMessage: "Photo library permission denied.");
    }
  }

  Future<void> processImageWithGreyscale() async {
    if (state.originalImage == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final result = await _service.applyGreyscale(state.originalImage!);
      state = state.copyWith(isLoading: false, processedImage: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: "Failed to process image: $e");
    }
  }
}

// Providers
final imageServiceProvider = Provider((ref) => ImageProcessingService());

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>((ref) {
  return ImageNotifier(ref.watch(imageServiceProvider));
});