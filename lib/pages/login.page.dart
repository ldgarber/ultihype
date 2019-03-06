import 'package:ultihype/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart'; 

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState(); 
} 

class _LoginPageState extends State<LoginPage> {
  String _status = ''; 

  FirebaseAuth _auth = FirebaseAuth.instance; 
  FirebaseUser myUser; 

  void _logInTwitter () { 
    setState(() => this._status = 'Loading...'); 
    _loginWithTwitter().then((response) {
      if (response != null) {
        myUser = response; 
        Navigator.of(context).pushReplacementNamed('/home'); 
      } else {
        setState(() => this._status = 'Error in log in, try again'); 
      } 
    });  
  } 

  Future<FirebaseUser> _loginWithTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: 'FxTaSf2ZBGlQ0wwi4Mw2nDv57',
      consumerSecret: 'nRMpbnhHCGfdLyp94BVzO47GzKuutcaTKNsDqys53cEzgMxSzO',
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        final AuthCredential credential = TwitterAuthProvider.getCredential(
          authToken: session.token, authTokenSecret: session.secret); 
        FirebaseUser user = await _auth.signInWithCredential(credential); 
        return user;  
        break;
      case TwitterLoginStatus.cancelledByUser:
        _showCancelMessage();
        return null; 
        break;
      case TwitterLoginStatus.error:
        _showErrorMessage(result);
        return null; 
        break;
    }
    return null; 
  } 

  void _showCancelMessage () {} 
  void _showErrorMessage (error) {}

  @override 
  Widget _logInScreen() { 
    return new Container(
      color: Colors.white.withOpacity(0.2), 
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: <Widget>[
            Text(
              "Sign Up or Sign In", 
              style: TextStyle(height: 3.0, fontSize: 22), 
            ), 
            Text(
              "${this._status}"
            ), 
            TwitterSignInButton(
              onPressed: _logInTwitter
            )        
          ]
        ) 
    ); //Container
  }

  Widget build(BuildContext context) => new Scaffold( 
    body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image(
              image: AssetImage('assets/playing-on-field.jpg'), 
              fit: BoxFit.fill, 
            ), 
          ), 
          Positioned.fill(
            child: _logInScreen(), 
          ), 
          AppBar(
            title: new Text('UltiHype'), 
            backgroundColor: Colors.transparent, 
          ), //appbar 
        ], //Widget list 
    ) //Stack
  ); //Scaffold 
} 
