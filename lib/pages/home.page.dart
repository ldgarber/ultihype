import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseAuth _auth = FirebaseAuth.instance; 

  FirebaseUser myUser; 
  String user_name; 
  String image_url; 

  void _signOut() async {
    _auth.signOut().then((response) {
      Navigator.of(context).pushReplacementNamed('/login'); 
    });  
  } 

  @override
  initState() {
    super.initState(); 
    _auth.onAuthStateChanged
        .firstWhere((user) => user != null) 
        .then((user) {
          user_name = user.displayName; 
          //image_url = user.photoUrl; 
        }); 
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UltiHype"),
        centerTitle: true, 
      ),
      body: Center(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                 "${myUser}"
                 "${user_name}"
                ), 
                //Image.network(image_url), 
                FlatButton(
                  child: const Text('Sign out'),
                  onPressed: () async {
                    await _signOut();
                  },
                )
              ],
            )
      ),
    );
  }
}
