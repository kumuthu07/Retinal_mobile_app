import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle tapping on About Us
            },
            padding: const EdgeInsets.only(right: 20.0),
            icon: const Icon(
              Icons.info_sharp,
              color: Colors.white,
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white), // Change back button color
      ),
      body: ListView(

        children: [
          Container(
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              padding: const EdgeInsets.all(20.0),
              decoration: (BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              )),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    // child: Text(
                    //   'RetinalRealm',
                    //   style: TextStyle(
                    //     color: Colors.orange.shade600,
                    //     fontSize: 35.0,
                    //     fontFamily: 'Salsa',
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/images/RetinalRealm.png",
                      height: 200.0,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'RetinalRealm is a mobile application that assists eye diseased patients in detecting thier eye diseases and helping thm with early detection so that they could take necessary precautions to reduce the risk of getting the disease. Users can get answers to their questions quickly and easily. RetinalRealm ensures consistency and will protect your vision.',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
          Container(
            margin:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            padding: const EdgeInsets.all(20.0),
            decoration: (BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            )),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Developed by',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Kumuthu Thotagamuwa',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'kumuthuthotagamuwa@gmail.com',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.facebook,
                        color: Colors.blueAccent,
                        size: 30.0,
                      ),
                      // Icon(
                      //   // Icons.instagram,
                      //   color: Colors.pink,
                      //   size: 30.0,
                      // ),
                      // Icon(
                      //   Icons.twitter,
                      //   color: Colors.lightBlue,
                      //   size: 30.0,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              ' Copyright ©2025 Final Year Project\nAll Rights Reserved.',
              style: TextStyle(
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }
}
