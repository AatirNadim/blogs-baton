import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'image_processor_bindings.dart'; // The generated file

class ImageProcessingService {
  late final ImageProcessorBindings _bindings;

  ImageProcessingService() {
    final dylib = Platform.isAndroid
        ? DynamicLibrary.open('libimage_processor.so')
        : DynamicLibrary.open('libimage_processor.dylib');
    _bindings = ImageProcessorBindings(dylib);
  }

  // This is a helper that will be run in an Isolate
  static Uint8List _applyGreyscaleIsolate(Uint8List imageBytes) {
    // Note: The service needs to be re-instantiated inside the isolate.
    final service = ImageProcessingService();
    return service._applyGreyscale(imageBytes);
  }

  // This is the public method called from the Notifier
  Future<Uint8List> applyGreyscale(Uint8List imageBytes) async {
    // Use compute to run the FFI call in a separate isolate
    return compute(_applyGreyscaleIsolate, imageBytes);
  }

  // The actual FFI call logic
  Uint8List _applyGreyscale(Uint8List imageBytes) {
    // 1. Allocate memory in C-land for the image bytes and copy data over
    final pointer = calloc<Uint8>(imageBytes.length);
    pointer.asTypedList(imageBytes.length).setAll(0, imageBytes);

    // 2. Call the Rust function
    final result = _bindings.apply_greyscale(pointer, imageBytes.length);

    // 3. Copy the result from C-land memory back to a Dart Uint8List
    final processedBytes = result.ptr.asTypedList(result.size).sublist(0);

    // 4. CRITICAL: Free the memory allocated by Rust and the pointer we created
    _bindings.free_memory(result.ptr, result.size);
    calloc.free(pointer);

    return processedBytes;
  }
}