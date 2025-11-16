import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ImageProcessingUtils {
  static Future<Map<String, dynamic>?> query(String filename) async {
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

        // If the maximum score is below a threshold, consider it as "Invalid Input"
        if (maxScore < 0.7) {
          maxLabel = 'Invalid Input';
        }

        if(maxLabel == 'Diabetes'){
          maxLabel = 'Diabetic Retinopathy';
        }
        // Construct the result map containing the label with the highest score
        Map<String, dynamic> result = {
          'maxLabel': maxLabel,
          'maxScore': maxScore,
          'image': file.path,
        };

        return result;
      } else {
        // Check if the response indicates that the model is currently loading
        String responseBody = response.body;
        if (responseBody.contains('Model SM200203102097/eyeDiseasesDetectionModel is currently loading')) {
          print('Model is currently loading. Please try again later.');
          // You may choose to handle this scenario differently, e.g., retrying after some time
        } else {
          print('Failed to load data. Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');
          throw Exception('Failed to load data');
        }
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }  }
}
