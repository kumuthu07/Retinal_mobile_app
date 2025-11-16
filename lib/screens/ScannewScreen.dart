import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> readFile(String filename) async {
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = '$appDocPath/$filename';
    File file = File(filePath);
    query(file.readAsString() as String);
    return await file.readAsString();
  } catch (e) {
    print('Error reading file: $e');
    throw Exception('Failed to read file');
  }
}

// Function to query the API
Future<Map<String, dynamic>> query(String filename) async {
  try {
    File file = File(filename);
    List<int> bytes = await file.readAsBytes();

    String url =
        'https://api-inference.huggingface.co/models/SM200203102097/eyeDiseasesDetectionModel';

    Map<String, String> headers = {
      'Authorization': 'Bearer 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',
    };

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: bytes, // Send the image data directly as bytes
    );

    if (response.statusCode == 200) {
      print('Success response: $response');
      print('Response body: ${response.body}');

      String responseBody = response.body;

      // Parse the JSON string into a List<Map<String, dynamic>>
      List<dynamic> predictions = jsonDecode(responseBody);

      // Initialize variables to hold the maximum score and corresponding label
      double maxScore = double.negativeInfinity;
      String maxLabel = '';

      // Iterate over the predictions to find the label with the maximum score
      for (var prediction in predictions) {
        String label = prediction['label'];
        double score = prediction['score'];

        if (score > maxScore) {
          maxScore = score;
          maxLabel = label;
        }
      }

      if(maxScore<0.7){
        maxLabel = 'Invalid Input';
      }
      // Construct the result map containing the label with the highest score
      Map<String, dynamic> result = {
        'maxLabel': maxLabel,
        'maxScore': maxScore,
      };

      return result;
    } else {
      print('Failed to load data. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load data');
  }
}



class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late File _imageFile;
  late Map<String, dynamic>? _output = null;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final output = await query(pickedFile.path);
      setState(() {
        _output = output;
      });
    }
  }



  // Function to handle image selection
  Future<void> _selectImage() async {
    print('select image');
    final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker
    final imageFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = imageFile as File;
    });

    if (_imageFile != null) {
      // Call the API
      final output = await query(_imageFile as String);
      setState(() {
        _output = output;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Classification"),
      ),
      body: Center(
        child: _output != null
            ? Text("Result: ${_output?['maxLabel']}") // Access specific keys from _output
            : Text("No image selected"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'Select Image',
        child: Icon(Icons.add),
      ),
    );
  }
}
