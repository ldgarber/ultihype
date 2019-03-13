import 'package:flutter/material.dart';
import 'package:ultihype/pages/home.page.dart';
import 'package:ultihype/pages/login.page.dart';
import 'package:ultihype/pages/add_team.page.dart'; 

class AppRootWidget extends StatefulWidget {
  @override 
  AppRootWidgetState createState() => new AppRootWidgetState(); 
} 

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
      primarySwatch: Colors.lightBlue,
      fontFamily: 'FugazOne', 
    );
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'UltiHype',
      theme: _themeData,
      debugShowCheckedModeBanner: false, 
      home: HomePage(),     
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(), 
        '/login': (BuildContext context) => new LoginPage(), 
        '/add_team': (BuildContext context) => new AddTeamPage(), 
      },  
    ); //Material App
  }
}

