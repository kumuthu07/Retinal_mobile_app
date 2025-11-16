import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'CameraView.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();
  bool feedbackSent=false;
  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // FirebaseFirestore.instance.settings = const Settings{
  //   persistanceEnabled: true,
  // }

  HomeScreen({super.key});



  Future<void> sendFeedback(String feedback) async {
    try {
      feedbackSent = false;
      final Timestamp createdOn = Timestamp.now();

      // Add feedback to Firestore
      await _firestore.collection('user_feedback').add({
        'feedback': feedback,
        'createdOn': createdOn,
      });
      feedbackSent = true;
      print('Success');

    } catch (error) {
      feedbackSent = false;
      print('Error sending feedback: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Eye Disease Detection'),
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Welcome to Eye Disease Detection App',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Image.asset(
              'assets/images/RetinalRealm.png', // Add image asset for eye detection
              height: 200.0,
              width: 200.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Detect eye diseases such as cataract, diabetic retinopathy, and glaucoma with ease using our advanced AI technology.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900, // Set button color to matte orange
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0), // Adjust padding for larger size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Add border radius for rounded corners
                ),
              ),
              onPressed: () {
                // Navigate to the screen for disease detection
                // Replace `DetectionScreen()` with the actual screen for disease detection
                Navigator.push(context, MaterialPageRoute(builder: (_) => CameraView()));
              },
              child: Text(
                'Start Disease Detection',
                style: TextStyle(
                  fontSize: 20.0, // Increase font size for better visibility
                  color: Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Text(
              'Provide Feedback / Report Issues',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: feedbackController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Type your feedback or report an issue here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900, // Set button color to matte orange
              ),
              onPressed: () async {

                // Validate and send feedback
                if (feedbackController.text.isNotEmpty) {
                  await sendFeedback(feedbackController.text);
                  if( feedbackSent == true){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Feedback sent successfully!')),
                    );
                    feedbackController.clear();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Feedback Failed to send!')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please provide your feedback or report an issue.')),
                  );
                }
              },
              child: Text('Send Feedback',
                style: TextStyle(
                  color: Colors.orange
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}