import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:ultihype/pages/home.page.dart';
import 'package:ultihype/pages/login.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  //set default home
  Widget _defaultHome = new LoginPage(); 

  // Intro Views pages: 
  final introPages = [ 
    PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        bubble: Image.asset('assets/stats.png'),
        body: Text(
          "Keep track of your team's goals, assists, and layout D's",
        ),
        title: Text(
          'TAKE STATS',
        ),
        textStyle: TextStyle(fontFamily: "FugazOne", color: Colors.white),
        mainImage: Image.asset(
          'assets/stats.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFFFF8a65),
      iconImageAssetPath: 'assets/twitter-icon.png',
      body: Text(
        'Live tweet with the click of a button',
      ),
      title: Text('TWEET'),
      mainImage: Image.asset(
        'assets/twitter-icon.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'FugazOne', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFFFFb74d),
      iconImageAssetPath: 'assets/hype.png',
      body: Text(
        'Never sacrifice hype for accurate stats again',
      ),
      title: Text('HYPE'),
      mainImage: Image.asset(
        'assets/hype.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'FugazOne', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UltiHype',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'FugazOne', 
       ),
      home: Builder( 
        builder: (context) => 
          IntroViewsFlutter(
            introPages, 
            onTapDoneButton: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => _defaultHome, 
                ),  
              ); 
            }, 
            fullTransition: 100.0, 
            doneButtonPersist: true, 
            pageButtonTextStyles:  TextStyle(
              fontFamily: 'FugazOne', 
              color:  Colors.white, 
              fontSize: 18.0, 
            ), 
          ), //IntroViewsFlutter
      ), //Builder
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(), 
        '/login': (BuildContext context) => new LoginPage()
      },  
    ); //Material App
  }
}

