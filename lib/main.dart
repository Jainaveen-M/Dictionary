import 'package:flutter/material.dart';
import './MyHomePage.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp( new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
    ),
    home:MyApp( ),
  ) );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 6,
      navigateAfterSeconds: MyHomePage(),
      loaderColor: Colors.blue,
    );
  }
}
