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