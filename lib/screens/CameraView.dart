import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'PreprocessImage.dart'; // <-- put your preprocessImage + predict in this file
import 'package:url_launcher/url_launcher.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late Interpreter _interpreter;
  bool _imageSelected = false;
  File? _image;
  bool _isLoading = false;
  Map<String, dynamic>? _output;
  String? _predictionLabel;
  double? _predictionScore;
  bool _isInterpreterReady = false;


  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }


  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/eye_model_float321002.tflite');
      setState(() => _isInterpreterReady = true);

      print("✅ Model loaded successfully!");

    } catch (e) {
      print("❌ Failed to load model: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _imageSelected = true;
        _isLoading = true;
      });
      await _classify(_image!);
    }
  }

  Future<void> _classify(File imageFile) async {
    if (!_isInterpreterReady) {
      print("❌ Interpreter not ready yet");
      return;
    }
    try {
      final results = await predict(_interpreter, imageFile);
      print("Prediction results: $results");

      // Get best prediction
      final best = results.first;

      setState(() {
        _predictionLabel = best['label'];
        _predictionScore = best['probability'];
        _isLoading = false;
      });

    } catch (e) {
      print("❌ Error classifying: $e");
    }
  }

  Widget _buildResultCard() {
    final label = _predictionLabel;
    final score = _predictionScore;
    print('results $label and $score');

    String displayText;
    // if ((label != 'normal' && score > 0.75 && label != 'glaucoma') ||
    //     (label == 'glaucoma' && score > 0.5)) {
    //   displayText =
    //   "Result: $label\nConfidence: ${(score * 100).toStringAsFixed(2)}%";
    // } else {
    //   displayText = "Result: No Disease Detected";
    // }

    displayText = "Result: $label\nConfidence: ${(score! * 100).toStringAsFixed(2)}%";

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 18,
            color: label == 'normal' ? Colors.blue : Colors.red,
          ),
        ),
      ),
    );
  }

  void _showSolutionDialog(String label) {
    String dialogText;

    switch (label.toLowerCase()) {
      case 'cataract':
        dialogText =
        'Cataract solutions...\nLow risk: update lenses, sunglasses.\nHigh risk: surgery required.';
        break;
      case 'diabetic_retinopathy':
        dialogText =
        'Diabetic Retinopathy solutions...\nLow risk: manage diabetes.\nHigh risk: injections, laser treatment.';
        break;
      case 'glaucoma':
        dialogText =
        'Glaucoma is treated by lowering intraocular pressure: eye drops, meds, or surgery.';
        break;
      case 'myopia':
        dialogText =
        'Myopia management: correct lenses, breaks during work, LASIK for high cases.';
        break;
      case 'amd':
        dialogText =
        'AMD management: healthy diet, anti-VEGF injections, lifestyle adjustments.';
        break;
      case 'hypertension':
        dialogText =
        'Hypertension management: healthy diet, exercise, meds, regular monitoring.';
        break;
      default:
        dialogText = 'Condition unclear — seek medical attention.';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Solution for $label"),
        content: Text(dialogText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }


  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Help"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Take a retinal photo using the adapter or upload a retinal image.",
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                const url = 'https://youtu.be/hEQGXDquCu4?si=_f2Jw5uJgTpNGqZ_';
                final uri = Uri.parse(url);

                try {
                  // Try external app (YouTube)
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    // Fallback: open inside app WebView
                    await launchUrl(uri, mode: LaunchMode.inAppWebView);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open video')),
                  );
                }
              },
              child: const Text(
                "🎥 Watch Tutorial on YouTube",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detect Disease'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showHelpDialog,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: _imageSelected
                ? Image.file(_image!)
                : Center(
              child: ElevatedButton(
                onPressed: _showHelpDialog,
                child: const Text("How to add image?"),
              ),
            ),
          ),
          if (_predictionLabel != null && _predictionLabel != '')
            _buildResultCard(),
          // if (_output != null &&
          //     ((_output!['label'] != 'normal' &&
          //         _output!['score'] > 0.75) ||
          //         (_output!['label'] == 'glaucoma' &&
          //             _output!['score'] > 0.5)))
          if (_predictionLabel != null && _predictionLabel != '')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _showSolutionDialog(_predictionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                ),
                child: const Text('View Solution'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _takePhoto();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CameraCaptureView(
                    //       onConfirmImage: confirmImage,
                    //     ),
                    //   ),
                    // );
                  },
                  child: const Text("Take a Photo"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Upload an Image"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _imageSelected = true;
        _isLoading = true;
      });
      await _classify(_image!); // classify the captured image
    }
  }
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: const Text("Retinal Disease Detection")),
//     body: _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : ListView(
//       children: [
//         if (_image != null)
//           Image.file(_image!, height: 250, fit: BoxFit.cover),
//         if (_output != null)
//           Card(
//             margin: const EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Text(
//                 "Prediction: ${_output!['label']}\n"
//                     "Confidence: ${(_output!['probability'] * 100).toStringAsFixed(2)}%",
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: _pickImage,
//           child: const Text("Upload an Image"),
//         ),
//       ],
//     ),
//   );
// }
}