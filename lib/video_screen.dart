import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class UploadVideoScreen extends StatefulWidget {
  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final picker = ImagePicker();
  Future<File?>? _videoFuture;
  String _message = '';
  File? _thumbnailFile;

  Future<void> _pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _videoFuture = Future.value(File(pickedFile.path));
        _message = '';
        _generateThumbnail(pickedFile.path);
      } else {
        _message = 'No video selected.';
      }
    });
  }

  Future<void> _generateThumbnail(String videoPath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 200, // specify the height of the thumbnail, let the width maintain aspect ratio
      quality: 75,
    );
    setState(() {
      if (thumbnailPath != null) {
        _thumbnailFile = File(thumbnailPath);
      }
    });
  }

  Future<void> _uploadVideo() async {
    final File? video = await _videoFuture;
    if (video == null) {
      setState(() {
        _message = 'No video selected.';
      });
      _showSnackBar(_message);
      return;
    }

    setState(() {
      _message = 'Uploading video...';
    });
    _showSnackBar(_message);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://b721-14-139-122-17.ngrok-free.app/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        video.path,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _message = 'Video uploaded successfully';
      });
    } else {
      setState(() {
        _message = 'Error uploading video';
      });
    }
    _showSnackBar(_message);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _thumbnailFile == null
                ? Text(_message)
                : Image.file(_thumbnailFile!),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
