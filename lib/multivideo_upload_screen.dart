// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:video_player/video_player.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// class MultiVideoUploadScreen extends StatefulWidget {
//   @override
//   _MultiVideoUploadScreenState createState() => _MultiVideoUploadScreenState();
// }

// class _MultiVideoUploadScreenState extends State<MultiVideoUploadScreen> {
//   List<String?> videoUrls = List.filled(5, null);
//   bool uploading = false;
//   int? selectedUserId;
//   List<int> questionIds = [];
//   VideoPlayerController? _videoPlayerController;

//   Future<void> _selectUser() async {
//     final selectedUser = await showDialog<int>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select User'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: Text('User 1'),
//                   onTap: () {
//                     Navigator.of(context).pop(1);
//                   },
//                 ),
//                 GestureDetector(
//                   child: Text('User 2'),
//                   onTap: () {
//                     Navigator.of(context).pop(2);
//                   },
//                 ),
//                 GestureDetector(
//                   child: Text('User 3'),
//                   onTap: () {
//                     Navigator.of(context).pop(3);
//                   },
//                 ),
//                  GestureDetector(
//                   child: Text('User 4'),
//                   onTap: () {
//                     Navigator.of(context).pop(3);
//                   },
//                 ),
//                  GestureDetector(
//                   child: Text('User 5'),
//                   onTap: () {
//                     Navigator.of(context).pop(3);
//                   },
//                 ),
//                  GestureDetector(
//                   child: Text('User 6'),
//                   onTap: () {
//                     Navigator.of(context).pop(3);
//                   },
//                 ),
//                 // Add more users as needed
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     if (selectedUser != null) {
//       setState(() {
//         selectedUserId = selectedUser;
//       });
//     }
//   }

//   Future<void> _selectVideo(int index) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
//     if (result != null) {
//       String? videoPath = result.files.single.path;
//       if (videoPath != null) {
//         setState(() {
//           videoUrls[index] = videoPath;
//           questionIds.add(DateTime.now().millisecondsSinceEpoch);
//         });
//       }
//     }
//   }

//   Future<void> _uploadVideos() async {
//     setState(() {
//       uploading = true;
//     });

//     if (videoUrls.any((element) => element == null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select all videos before uploading.'),
//         ),
//       );
//       setState(() {
//         uploading = false;
//       });
//       return;
//     }

//     if (selectedUserId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select a user before uploading.'),
//         ),
//       );
//       setState(() {
//         uploading = false;
//       });
//       return;
//     }

//     try {
//       var request = http.MultipartRequest(
//           'POST', Uri.parse('https://3bac-14-139-122-17.ngrok-free.app/upload/$selectedUserId'));

//       for (int i = 0; i < questionIds.length; i++) {
//         request.fields['questionIds[$i]'] = questionIds[i].toString();
//       }

//       for (int i = 0; i < 5; i++) {
//         if (videoUrls[i] != null) {
//           String videoPath = videoUrls[i]!;
//           request.files.add(await http.MultipartFile.fromPath('videos', videoPath));
//         }
//       }

//       var response = await request.send();

//       if (response.statusCode == 200) {
//         setState(() {
//           videoUrls = List.filled(5, null);
//           questionIds.clear();
//           uploading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Videos uploaded successfully!'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to upload videos. Please try again later.'),
//           ),
//         );
//         setState(() {
//           uploading = false;
//         });
//       }
//     } catch (e) {
//       print('Error uploading videos: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to upload videos. Please try again later.'),
//         ),
//       );
//       setState(() {
//         uploading = false;
//       });
//     }
//   }

//   void _initializeVideoPlayer(String url) {
//     _videoPlayerController = VideoPlayerController.network(url)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoPlayerController!.play();
//       });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.dispose();
//     super.dispose();
//   }

//   String _getFileName(String path) {
//     return path.split(Platform.pathSeparator).last;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Upload'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _selectUser,
//             child: Text('Select User'),
//           ),
//           SizedBox(height: 20),
//           for (int i = 0; i < 5; i++)
//             ListTile(
//               title: Text('Question ${i + 1}'),
//               subtitle: videoUrls[i] != null
//                   ? Text('Selected Video: ${_getFileName(videoUrls[i]!)}')
//                   : Text('Yet not selected'),
//               trailing: OutlinedButton(
//                 onPressed: () => _selectVideo(i),
//                 child: Text('Select Video'),
//               ),
//             ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _uploadVideos,
//             child: Text('Upload Videos'),
//           ),
//           SizedBox(height: 20),
//           if (uploading) LinearProgressIndicator(),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MultiVideoUploadScreen extends StatefulWidget {
  @override
  _MultiVideoUploadScreenState createState() => _MultiVideoUploadScreenState();
}

class _MultiVideoUploadScreenState extends State<MultiVideoUploadScreen> {
  List<String?> videoUrls = List.filled(5, null);
  bool uploading = false;
  int? selectedUserId;
  List<int> questionIds = [];
  VideoPlayerController? _videoPlayerController;

  // Define your users here
  List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'User 1'},
    {'id': 2, 'name': 'User 2'},
    {'id': 3, 'name': 'User 3'},
    {'id': 4, 'name': 'User 4'},
    {'id': 5, 'name': 'User 5'},
    {'id': 6, 'name': 'User 6'},
    {'id': 7, 'name': 'User 7'},
    {'id': 8, 'name': 'User 8'},
    {'id': 9, 'name': 'User 9'},
    {'id': 10, 'name': 'User 10'},
    {'id': 11, 'name': 'User 11'},
    {'id': 12, 'name': 'User 12'},
    {'id': 13, 'name': 'User 13'},
    {'id': 14, 'name': 'User 14'},
    {'id': 15, 'name': 'User 15'},
    {'id': 16, 'name': 'User 16'},
    {'id': 17, 'name': 'User 17'},
    {'id': 18, 'name': 'User 18'},
    {'id': 19, 'name': 'User 19'},
    {'id': 20, 'name': 'User 20'},
    {'id': 21, 'name': 'User 21'},
    {'id': 22, 'name': 'User 22'},
    {'id': 23, 'name': 'User 23'},
    {'id': 24, 'name': 'User 24'},
    {'id': 25, 'name': 'User 25'},
    {'id': 26, 'name': 'User 26'},
    {'id': 27, 'name': 'User 27'},
    {'id': 28, 'name': 'User 28'},
    {'id': 29, 'name': 'User 29'},
    {'id': 30, 'name': 'User 30'},
    {'id': 31, 'name': 'User 31'},
    {'id': 32, 'name': 'User 32'},
    {'id': 33, 'name': 'User 33'},
    {'id': 34, 'name': 'User 34'},
    {'id': 35, 'name': 'User 35'},
    {'id': 36, 'name': 'User 36'},
    {'id': 37, 'name': 'User 37'},
    {'id': 38, 'name': 'User 38'},
    {'id': 39, 'name': 'User 39'},
    {'id': 40, 'name': 'User 40'},
    {'id': 41, 'name': 'User 41'},
    {'id': 42, 'name': 'User 42'},
    {'id': 43, 'name': 'User 43'},
    {'id': 44, 'name': 'User 44'},
    {'id': 45, 'name': 'User 45'},
    {'id': 46, 'name': 'User 46'},
    {'id': 47, 'name': 'User 47'},
    {'id': 48, 'name': 'User 48'},
    {'id': 49, 'name': 'User 49'},
    {'id': 50, 'name': 'User 50'},
  ];

  Future<void> _selectUser() async {
    final selectedUser = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select User'),
          content: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ListBody(
              children: [
                for (var user in users)
                  GestureDetector(
                    child: ListTile(
                      title: Text(user['name']),
                      onTap: () {
                        Navigator.of(context).pop(user['id']);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedUser != null) {
      setState(() {
        selectedUserId = selectedUser;
      });
    }
  }

  Future<void> _selectVideo(int index) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      String? videoPath = result.files.single.path;
      if (videoPath != null) {
        setState(() {
          videoUrls[index] = videoPath;
          questionIds.add(DateTime.now().millisecondsSinceEpoch);
        });
      }
    }
  }

  Future<void> _uploadVideos(int userId) async {
    // Accept user ID as parameter
    setState(() {
      uploading = true;
    });

    if (videoUrls.any((element) => element == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select all videos before uploading.'),
        ),
      );
      setState(() {
        uploading = false;
      });
      return;
    }

    if (userId == null) {
      // Check against provided user ID
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a user before uploading.'),
        ),
      );
      setState(() {
        uploading = false;
      });
      return;
    }

    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://ae75-14-139-122-17.ngrok-free.app/upload/$userId'));

      for (int i = 0; i < questionIds.length; i++) {
        request.fields['questionIds[$i]'] = questionIds[i].toString();
      }

      for (int i = 0; i < 5; i++) {
        if (videoUrls[i] != null) {
          String videoPath = videoUrls[i]!;
          request.files
              .add(await http.MultipartFile.fromPath('videos', videoPath));
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          videoUrls = List.filled(5, null);
          questionIds.clear();
          uploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Videos uploaded successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload videos. Please try again later.'),
          ),
        );
        setState(() {
          uploading = false;
        });
      }
    } catch (e) {
      print('Error uploading videos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload videos. Please try again later.'),
        ),
      );
      setState(() {
        uploading = false;
      });
    }
  }

  void _initializeVideoPlayer(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController!.play();
      });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  String _getFileName(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Upload'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _selectUser,
            child: Text('Select User'),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < 5; i++)
            ListTile(
              title: Text('Question ${i + 1}'),
              subtitle: videoUrls[i] != null
                  ? Text('Selected Video: ${_getFileName(videoUrls[i]!)}')
                  : Text('Yet not selected'),
              trailing: OutlinedButton(
                onPressed: () => _selectVideo(i),
                child: Text('Select Video'),
              ),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedUserId != null) {
                _uploadVideos(selectedUserId!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select a user before uploading.'),
                  ),
                );
              }
            },
            child: Text('Upload Videos'),
          ),
          SizedBox(height: 20),
          if (uploading) LinearProgressIndicator(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
