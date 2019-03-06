import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return new SplashScreen(
      title: new Text('Welcome to UltiHype', 
          style: new TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20.0
              ), 
          ), 
      image: new Image.network('https://i.imgur.com/TyCSG9A.png'), 
      backgroundColor: Colors.white, 
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.red
    );  
  }
} 
