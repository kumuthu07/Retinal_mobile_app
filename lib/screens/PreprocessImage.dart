import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Labels must match training order
final List<String> labels = [
  'cataract',
  'diabetic_retinopathy',
  'glaucoma',
  'normal',
  'random_images'
];

/// Preprocess image for TFLite model
/// - Resize to 224x224
/// - Convert to float32
/// - No normalization (Rescaling is inside the model)
/// - Add batch dimension [1,224,224,3]
List<List<List<List<double>>>> preprocessImage(
    File imageFile, {int targetWidth = 224, int targetHeight = 224}) {
  final bytes = imageFile.readAsBytesSync();
  img.Image? image = img.decodeImage(bytes);
  if (image == null) throw Exception("❌ Cannot decode image");

  // Resize
  image = img.copyResize(image, width: targetWidth, height: targetHeight);

  // Convert to float32 [224][224][3]
  var input = List.generate(targetHeight, (y) {
    return List.generate(targetWidth, (x) {
      final pixel = image!.getPixel(x, y);
      return [
        img.getRed(pixel).toDouble(),
        img.getGreen(pixel).toDouble(),
        img.getBlue(pixel).toDouble(),
      ];
    });
  });

  // Debug info: min, max, mean
  double minVal = double.infinity;
  double maxVal = double.negativeInfinity;
  double sum = 0;
  int count = 0;
  for (var row in input) {
    for (var col in row) {
      for (var c in col) {
        minVal = c < minVal ? c : minVal;
        maxVal = c > maxVal ? c : maxVal;
        sum += c;
        count++;
      }
    }
  }
  print("Input min/max/mean: $minVal / $maxVal / ${sum / count}");

  // Add batch dimension [1,224,224,3]
  return [input];
}

/// Run prediction on image
Future<List<Map<String, dynamic>>> predict(
    Interpreter interpreter, File imageFile) async {
  // Preprocess
  final input = preprocessImage(imageFile);

  // Prepare output buffer
  final outputShape = interpreter.getOutputTensor(0).shape; // [1, num_classes]
  final output =
  List.filled(outputShape[1], 0.0).reshape([1, outputShape[1]]);

  // Run inference
  interpreter.run(input, output);

  // Map probabilities to labels
  List<Map<String, dynamic>> results = [];
  for (int i = 0; i < output[0].length; i++) {
    results.add({
      'probability': output[0][i],
      'index': i,
      'label': labels[i],
    });
  }

  // Sort by probability
  results.sort((a, b) => b['probability'].compareTo(a['probability']));

  // Debug logs
  print("Raw TFLite output: ${output[0]}");
  print("Predicted: ${results.first['label']} "
      "(${(results.first['probability'] * 100).toStringAsFixed(2)}%)");

  return results;
}