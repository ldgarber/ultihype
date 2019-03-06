import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:ultihype/pages/home.page.dart';
import 'package:ultihype/pages/login.page.dart';
import 'package:ultihype/pages/intropages.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  FirebaseAuth _auth = FirebaseAuth.instance; 

  //set default home
  Widget _defaultHome = new LoginPage(); 

  //need to check for logged in user and set _defaultHome accordingly

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
            //grab intro pages from other file
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

