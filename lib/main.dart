import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

import 'signin.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 10,
      navigateAfterSeconds: SignIn(),
      title: Text(
        'WhatsUp !',
        style: GoogleFonts.lato(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      image: Image.network(
        'https://image.flaticon.com/icons/png/512/129/129566.png',
      ),
      photoSize: 80,
      loaderColor: Colors.pink.shade100,
      loadingText: Text(
        'Connecting people.\nAlways.',
        style: TextStyle(fontSize: 20,color: Colors.black45),
        textAlign: TextAlign.center,
      ),
    );
  }
}
