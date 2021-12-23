import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/provider.dart/menu_provider.dart';
import 'package:text_recognition/provider.dart/text_recognition_provider.dart';
import 'package:text_recognition/screens/menu.dart';

// import 'screens/input_camera_view.dart';
// import 'screens/input_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TextRecognitionState()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryTextTheme: const TextTheme(
            headline6: TextStyle(color: Colors.white),
          ),
        ),
        home: const MenuScreen(),
      ),
    );
  }
}
