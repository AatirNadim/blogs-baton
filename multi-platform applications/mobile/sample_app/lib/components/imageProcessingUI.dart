import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/image_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);
    final imageNotifier = ref.read(imageProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Rust Image Processor')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageState.errorMessage != null)
                Text(
                  'Error: ${imageState.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              if (imageState.originalImage == null)
                ElevatedButton(
                  onPressed: () => imageNotifier.pickImage(),
                  child: const Text('Pick an Image'),
                ),

              if (imageState.originalImage != null) ...[
                const Text(
                  'Original Image:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Image.memory(imageState.originalImage!),
                const SizedBox(height: 20),
                if (imageState.isLoading)
                  const CircularProgressIndicator()
                else if (imageState.processedImage != null) ...[
                  const Text(
                    'Processed Image:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Image.memory(imageState.processedImage!),
                ],
              ],
            ],
          ),
        ),
      ),
      floatingActionButton:
          imageState.originalImage != null && !imageState.isLoading
          ? FloatingActionButton.extended(
              onPressed: () => imageNotifier.processImageWithGreyscale(),
              label: const Text('Apply Greyscale'),
              icon: const Icon(Icons.palette),
            )
          : null,
    );
  }
}
