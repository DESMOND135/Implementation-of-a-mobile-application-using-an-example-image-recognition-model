import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ImageClassifier {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> _loadLabels() async {
    final labelData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelData.split('\n');
  }

  Future<void> loadModel() async {
    try {
      // Loading the TFLite model from the assets folder
      _interpreter = await Interpreter.fromAsset('assets/mobilenet.tflite');
      // Loading text labels
      await _loadLabels();
      print('Model loaded successfully.');
    } catch (e) {
      print('Error while loading the model: $e');
    }
  }

  Future<String> classifyImage(File imageFile) async {
    if (_interpreter == null || _labels == null) {
      return "Model has not been initialized.";
    }

    // Pre-processing
    final imageData = imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(imageData);
    if (image == null) return "Image decoding error.";

    // Resize to 224x224 (required for MobileNet)
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Converting the image to a flat list (for quantized Uint8 model)
    var input = List.generate(
      1,
      (i) => List.generate(
        224,
        (j) => List.generate(
          224,
          (k) => List.generate(3, (l) => 0),
        ),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = pixel.r.toInt(); // Red
        input[0][y][x][1] = pixel.g.toInt(); // Green
        input[0][y][x][2] = pixel.b.toInt(); // Blue
      }
    }

    // Output buffer
    var output = List<int>.filled(1 * 1001, 0).reshape([1, 1001]);

    // Inference
    _interpreter!.run(input, output);

    // Post-processing
    int highestProbabilityIndex = 0;
    int highestProbability = 0;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highestProbability) {
        highestProbability = output[0][i] as int;
        highestProbabilityIndex = i;
      }
    }

    // Result
    if (highestProbabilityIndex < _labels!.length) {
      String label = _labels![highestProbabilityIndex];
      double confidence = (highestProbability / 255.0) * 100;
      return "Result: $label\n(Confidence: ${confidence.toStringAsFixed(2)}%)";
    } else {
      return "Object not recognized.";
    }
  }
}
