import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart'; 
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:ultihype/models/app_state.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/pages/intropages.dart'; 
import 'package:ultihype/pages/home.page.dart'; 

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState(); 
} 

class _LoginPageState extends State<LoginPage> {
  AppState appState; 

  void _showCancelMessage () {} 
  void _showErrorMessage (error) {}

  Widget get _introViews {
    var container = AppStateContainer.of(context); 

    return new Builder( 
        builder: (context) => 
          IntroViewsFlutter(
            //grab intro pages from other file
            introPages, 
            onTapDoneButton: () {
              container.setIntroViewsToSeen(); 
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
    ); //Builder
  }

  Widget get _pageToDisplay {
    var result = appState.didSeeIntroViews ? _loginLandingPage : _introViews; 
    return Builder(builder: (context) {
      return result;  
    }); 
  } 

  Widget get _loginLandingPage {
    var container = AppStateContainer.of(context); 

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
            centerTitle: true, 
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
                  appState.isLoading  
                    ? new CircularProgressIndicator() 
                    : TwitterSignInButton(
                      onPressed: container.logIntoFirebase
                    ),          
                ]
              )  
            ) //Container
          ), 
        ], //Widget list 
      ) //Stack
    ); //Scaffold 
  } 

  @override 
  Widget build(BuildContext context) {     
    final container = AppStateContainer.of(context); 
    appState = container.state; 

    var width = MediaQuery.of(context).size.width; 

    return new Builder(
      builder: (context) => 
        _pageToDisplay 
    );  
  } //build 
} 
