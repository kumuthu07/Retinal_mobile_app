import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'AboutUsScreen.dart';
import 'CameraView.dart';
import 'Home.dart';
import 'NewsScreen.dart';
import 'Chatbot.dart';
import 'ScannewScreen.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  Color myOrange = Color(0xFFFFA500);

  List<Widget> _screens = [
    HomeScreen(),
    CameraView(),
    // ScannerScreen(),
    Chatbot(),
    NewsScreen(),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }


  void signUserOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and logout the user
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true, // Center the title
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          },
        ),
        title: Text(
          'RetinalRealm', // Add the name 'RetinalRealm'
          style: TextStyle(
            fontFamily: 'Salsa',
            color: Colors.orange, // Set the color to orange
            fontSize: 24, // Set the font size
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
              child: Text(
                'RetinalRealm',
                style: TextStyle(
                  fontFamily: 'Salsa',
                  color: Colors.orange,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsScreen()));

              //   Navigator.pop(context);
              //   // Handle tapping on About Us
              },
            ),
            // ListTile(
            //   title: Text('Settings'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Handle tapping on Settings
            //   },
            // ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        color: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.grey.shade900,
            color: Colors.white,
            gap: 8,
            tabBackgroundColor: Colors.orange,
            onTabChange: _onItemTapped,
            padding: EdgeInsets.all(16),
            duration: Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.camera, text: 'Capture'),
              GButton(icon: Icons.assistant, text: 'ChatBot'),
              GButton(icon: Icons.article_outlined, text: 'News'),
            ],
          ),
        ),
      ),
    );
  }
}
