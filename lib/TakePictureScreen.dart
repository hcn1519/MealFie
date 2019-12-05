import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

class TakePictureScreen extends StatefulWidget {

  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  Timer _timer;
  String _dateStr = DateFormat("yyyy년 M월 dd일 HH시 mm ss").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    startTimer();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        var now = new DateTime.now();
        var dateStr = DateFormat("yyyy년 M월 dd일 HH시 mm분 ss초").format(now);
        _dateStr = dateStr;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Take a picture')),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var previewLength = MediaQuery.of(context).size.width;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: previewLength,
                          height: previewLength,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: CameraPreview(_controller),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Text(_dateStr, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 30)),
                        ),
                      ],
                    )
                  ],
                );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: () async {

                await _initializeControllerFuture;
                final path = join(
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );
                // 촬영
                await _controller.takePicture(path);

                File imageFile = File('$path');
                // 이미지를 사진 앱에 저장
                await ImagePickerSaver.saveFile(fileData: await imageFile.readAsBytes());

            },
          ),
        ),
      );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}