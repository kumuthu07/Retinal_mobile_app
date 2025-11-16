import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoading = false;
  late List<dynamic> _newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });

    final apiKey = 'df9bdc06769047039fb22200745de63d'; // Replace with your actual API key
    final apiUrl = 'https://newsapi.org/v2/everything?q=ophthalmology&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = json.decode(response.body);
      setState(() {
        _newsList = responseData['articles'];
        _isLoading = false; // Stop loading indicator
      });
    } catch (error) {
      print('Error fetching news: $error');
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eye Disease News',
          style: TextStyle(
            // fontFamily: Salsa,
            fontSize: 24, // Adjust font size as needed
            fontWeight: FontWeight.bold, // Make text bold
            color: Colors.black87, // Set text color
          ),
        ),
        centerTitle: true, // Center the title horizontally
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildNewsList(),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        final article = _newsList[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            title: Text(article['title']),
            subtitle: Text(article['description'] ?? ''),
            onTap: () {
              print(article['url']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsWebView(url: article['url']),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
class NewsWebView extends StatefulWidget {
  final String url;

  const NewsWebView({Key? key, required this.url}) : super(key: key);

  @override
  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Article',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller), // ✅ WebView displays inside app
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
