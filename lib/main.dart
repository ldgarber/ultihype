import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UltiHype',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UltiHype Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance; 
  bool isLogged = false; 

  FirebaseUser myUser; 

  void _logInTwitter () { 
    _loginWithTwitter().then((response) {
      if (response != null) {
        myUser = response; 
        isLogged = true; 
        setState(() {}); 
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: isLogged 
          ? null 
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TwitterSignInButton(
                  onPressed: _logInTwitter
                ) 
              ],
            ),
      ),
    );
  }
}
