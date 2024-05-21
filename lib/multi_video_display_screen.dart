// import 'dart:async';
// import 'dart:io';
// import 'package:archive/archive_io.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';

// class MultiVideoDisplayScreen extends StatefulWidget {
//   @override
//   _MultiVideoDisplayScreenState createState() =>
//       _MultiVideoDisplayScreenState();
// }

// class _MultiVideoDisplayScreenState extends State<MultiVideoDisplayScreen> {
//   List<File> videos = [];
//   bool isFetching = false;
//   String fetchMessage = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _fetchAndUnzipVideos() async {
//     setState(() {
//       isFetching = true;
//       fetchMessage = 'Fetching videos...';
//     });

//     try {
//       // Replace URL with your server endpoint to fetch the zip file
//       String zipUrl = 'https://0e45-14-139-122-17.ngrok-free.app/watch/6';

//       final response = await http.get(Uri.parse(zipUrl));
//       if (response.statusCode == 200) {
//         Directory tempDir = await getTemporaryDirectory();
//         File tempZipFile = File('${tempDir.path}/videos.zip');
//         await tempZipFile.writeAsBytes(response.bodyBytes);

//         // Unzip the received zip file
//         final bytes = File('${tempDir.path}/videos.zip').readAsBytesSync();
//         final archive = ZipDecoder().decodeBytes(bytes);

//         // Create a directory to store unzipped videos
//         Directory videoDir = Directory('${tempDir.path}/unzipped_videos');
//         if (!videoDir.existsSync()) {
//           videoDir.createSync();
//         }

//         // Extract videos from the zip file
//         for (final file in archive) {
//           final fileName = '${videoDir.path}/${file.name}';
//           if (file.isFile) {
//             final data = file.content as List<int>;
//             File(fileName).writeAsBytesSync(data);
//             videos.add(File(fileName));
//           }
//         }

//         setState(() {
//           isFetching = false;
//           fetchMessage = '';
//         }); // Trigger UI update after videos are fetched
//       } else {
//         setState(() {
//           isFetching = false;
//           fetchMessage = 'Failed to fetch videos';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isFetching = false;
//         fetchMessage = 'Error: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Videos'),
//       ),
//       body: Column(
//         children: [
//           if (isFetching)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//           if (fetchMessage.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(fetchMessage),
//             ),
//           Expanded(
//             child: PageView.builder(
//               itemCount: videos.length,
//               itemBuilder: (context, index) {
//                 return VideoPlayerWidget(file: videos[index]);
//               },
//             ),
//           ),

//           ElevatedButton(
//             onPressed: isFetching ? null : _fetchAndUnzipVideos,
//             child: Text('Fetch Videos'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final File file;

//   const VideoPlayerWidget({Key? key, required this.file}) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(widget.file);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true); // Loop the video
//     _controller.play(); // Autoplay the video
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }











import 'dart:async';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class MultiVideoDisplayScreen extends StatefulWidget {
  @override
  _MultiVideoDisplayScreenState createState() => _MultiVideoDisplayScreenState();
}

class _MultiVideoDisplayScreenState extends State<MultiVideoDisplayScreen> {
  List<File> videos = [];
  bool isFetching = false;
  String fetchMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchAndUnzipVideos(String userId) async {
    setState(() {
      isFetching = true;
      fetchMessage = 'Fetching videos...';
    });

    try {
      // Replace URL with your server endpoint to fetch the zip file
      String zipUrl = 'https://684c-14-139-122-17.ngrok-free.app/watch/$userId';

      final response = await http.get(Uri.parse(zipUrl));
      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        File tempZipFile = File('${tempDir.path}/videos.zip');
        await tempZipFile.writeAsBytes(response.bodyBytes);

        // Unzip the received zip file
        final bytes = File('${tempDir.path}/videos.zip').readAsBytesSync();
        final archive = ZipDecoder().decodeBytes(bytes);

        // Create a directory to store unzipped videos
        Directory videoDir = Directory('${tempDir.path}/unzipped_videos');
        if (!videoDir.existsSync()) {
          videoDir.createSync();
        }

        // Extract videos from the zip file
        for (final file in archive) {
          final fileName = '${videoDir.path}/${file.name}';
          if (file.isFile) {
            final data = file.content as List<int>;
            File(fileName).writeAsBytesSync(data);
            videos.add(File(fileName));
          }
        }

        setState(() {
          isFetching = false;
          fetchMessage = '';
        }); // Trigger UI update after videos are fetched
      } else {
        setState(() {
          isFetching = false;
          fetchMessage = 'Failed to fetch videos';
        });
      }
    } catch (e) {
      setState(() {
        isFetching = false;
        fetchMessage = 'Error: $e';
      });
    }
  }

  Future<void> _showFetchOptionsDialog() async {
    String? selectedOption = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempOption;
        return AlertDialog(
          title: Text(
            'Select User',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select User',
                border: OutlineInputBorder(),
              ),
              items: <String>[for (int i = 1; i <= 50; i++) 'User $i']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                tempOption = newValue;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: Text(
                'Fetch',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(tempOption);
              },
            ),
          ],
        );
      },
    );

    if (selectedOption != null) {
      _fetchAndUnzipVideos(selectedOption.split(' ')[1]); // Extract user ID from 'User X'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Column(
        children: [
          if (isFetching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          if (fetchMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(fetchMessage),
            ),
          Expanded(
            child: PageView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return VideoPlayerWidget(file: videos[index]);
              },
            ),
          ),
          ElevatedButton(
            onPressed: isFetching ? null : _showFetchOptionsDialog,
            child: Text('Fetch Videos'),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File file;

  const VideoPlayerWidget({Key? key, required this.file}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true); // Loop the video
    _controller.play(); // Autoplay the video
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
