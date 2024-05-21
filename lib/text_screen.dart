import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class TextDisplay extends StatefulWidget {
  @override
  _TextDisplayState createState() => _TextDisplayState();
}

class _TextDisplayState extends State<TextDisplay> {
  String message = '';
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://9c10-103-81-94-25.ngrok-free.app/api/data'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        message = data['message'];
        isLoading = false;
      });
    } else {
      setState(() {
        message = 'Failed to fetch data';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchData(); // Uncomment this line if you want to fetch data on app startup
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flask API Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: fetchData,
                child: Text('Fetch Data'),
              ),
              SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator() // Show loading indicator while fetching data
              else if (message.isNotEmpty)
                Text(message) // Display data if available
            ],
          ),
        ),
      ),
    );
  }
}
