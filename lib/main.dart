import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'TakePictureScreen.dart';

void main() {
  runApp(MealFieApp());
}

class MealFieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'MealFie';

    return MaterialApp(
      title: title,
      home: MainListScreen(),
    );
  }
}

class MainListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MealFie'),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              ),
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            final cameras = await availableCameras();
            final firstCamera = cameras.first;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureScreen(camera: firstCamera,),
              ),
            );
          },
        ),
      );
  }
}

//Future<void> main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//
//  // Obtain a list of the available cameras on the device.
//  final cameras = await availableCameras();
//
//  // Get a specific camera from the list of available cameras.
//  final firstCamera = cameras.first;
//
//  runApp(
//    MaterialApp(
//      theme: ThemeData.dark(),
//      home: TakePictureScreen(
//        // Pass the appropriate camera to the TakePictureScreen widget.
//        camera: firstCamera,
//      ),
//    ),
//  );
//}
