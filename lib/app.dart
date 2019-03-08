import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:ultihype/pages/intropages.dart'; 
import 'package:ultihype/pages/splash.page.dart'; 
import 'package:ultihype/pages/home.page.dart';
import 'package:ultihype/pages/login.page.dart';

class AppRootWidget extends StatefulWidget {
  @override 
  AppRootWidgetState createState() => new AppRootWidgetState(); 
} 

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
      primarySwatch: Colors.lightBlue,
      fontFamily: 'FugazOne', 
    );

// Widget _handleCurrentScreen() { OLD
//      return new StreamBuilder<FirebaseUser>(
//        stream: _auth.onAuthStateChanged,
//        builder: (BuildContext context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.waiting) {
//            return new SplashPage();
//         } else {
//          if (snapshot.hasData) {
//             return new HomePage();
//           }
//           return new LoginPage();
//         }
//       }
//     );
//}
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UltiHype',
      theme: _themeData,
      debugShowCheckedModeBanner: false, 
      home: Builder( 
        builder: (context) => 
          IntroViewsFlutter(
            //grab intro pages from other file
            introPages, 
            onTapDoneButton: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => new HomePage(), 
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

