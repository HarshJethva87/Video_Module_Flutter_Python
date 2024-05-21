import 'package:flutter/material.dart';
import 'package:video_upload_module/multi_video_display_screen.dart';
import 'package:video_upload_module/multivideo_upload_screen.dart';
import 'package:video_upload_module/video_screen.dart';
import 'display_video_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/upload': (context) => UploadVideoScreen(),
        '/display': (context) => SingleVideoDisplayScreen(),
        '/muiltivideoupload': (context) => MultiVideoUploadScreen(),
        '/muiltivideodisplay': (context) => MultiVideoDisplayScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/upload');
              },
              child: Text('Upload Video'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/display');
              },
              child: Text('Display Video'),
            ),
              ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/muiltivideoupload');
              },
              child: Text('Multi Video Upload'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/muiltivideodisplay');
              },
              child: Text('Multi Video Display'),
            ),
          
          ],
        ),
      ),
    );
  }
}
