import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart'; 
import 'package:ultihype/app_state_container.dart'; 

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState(); 
} 

class _LoginPageState extends State<LoginPage> {
  void _showCancelMessage () {} 
  void _showErrorMessage (error) {}

  @override 
  Widget build(BuildContext context) {    
 
    final container = AppStateContainer.of(context); 
    var width = MediaQuery.of(context).size.width; 

    return new Scaffold( 
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image(
              image: AssetImage('assets/playing-on-field.jpg'), 
              fit: BoxFit.fill, 
            ), 
          ), 
          AppBar(
            title: new Text('UltiHype'), 
            backgroundColor: Colors.white.withOpacity(0.2), 
          ), //appbar 
          Positioned.fill(
            child: new Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: <Widget>[
                  Text(
                    "Sign Up or Sign In", 
                    style: TextStyle(height: 3.0, fontSize: 22), 
                  ), 
                  TwitterSignInButton(
                    onPressed: container.logIntoFirebase
                  )        
                ]
              )  
            ) //Container
          ), 
        ], //Widget list 
      ) //Stack
    ); //Scaffold 
  } //build 
} 
