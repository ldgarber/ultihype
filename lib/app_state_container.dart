import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter_twitter_login/flutter_twitter_login.dart'; 
import 'package:flutter/foundation.dart'; 
import 'dart:async'; 
import 'package:ultihype/models/app_state.dart'; 

class AppStateContainer extends StatefulWidget {
  // Your apps state is managed by the container
  final AppState state;
  // This widget is simply the root of the tree,
  // so it has to have a child!
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;

  final FirebaseAuth _auth = FirebaseAuth.instance;     
  final Firestore firestore = Firestore.instance; 
  CollectionReference get teams => firestore.collection('teams'); 

  final twitterLogin = new TwitterLogin(
    consumerKey: 'FxTaSf2ZBGlQ0wwi4Mw2nDv57',
    consumerSecret: 'nRMpbnhHCGfdLyp94BVzO47GzKuutcaTKNsDqys53cEzgMxSzO',
  );

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state; 
    } else {
      state = new AppState.loading(); 
      initUser(); 
    } 
  }

  Future initUser() async {
    var twitterUser = await _auth.currentUser(); 
    if (twitterUser == null) {
      setState(() {
        state.isLoading = false; 
      }); 
    } else {
      var firebaseUser = twitterUser; 
      setState(() {
        state.isLoading = false; 
      }); 
    } 
  } 
  
  logIntoFirebase() async {
    FirebaseUser firebaseUser; 

    try {
      TwitterLoginResult result = await twitterLogin.authorize();
      setState(() { state.isLoading = true;}); 

      var session = result.session;
      final AuthCredential credential = TwitterAuthProvider.getCredential(
        authToken: session.token ?? '', 
        authTokenSecret: session.secret ?? ''); 

      firebaseUser = await _auth.signInWithCredential(credential); 

      print('Logged in: ${firebaseUser.displayName}');
      setState(() {
        state.isLoading = false;
        state.user = firebaseUser;
      });
    } catch (error) {
      print(error);
      setState(() {
        state.isLoading = false; 
      }); 
      return null;
    }
  } 

  void setIntroViewsToSeen() { 
    setState(() {
      state.didSeeIntroViews = true; 
    }); 
  } 

  void signOut() async {
    _auth.signOut().then((response) {
      setState(() { 
        state.user = null;  
      }); 
    });  
  } 

  Future<void> addTeam(String team_name) async {
    await teams.add(<String, String>{
      'team_name': team_name, 
      'uid': state.user.uid, 
    }); 
  } 

  StreamBuilder<QuerySnapshot> getTeamNames() {
    return StreamBuilder<QuerySnapshot>(
      stream: teams.where("uid", isEqualTo: state.user.uid).snapshots(), 
      builder: (BuildContext context, 
                AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
                children: snapshot.data.documents.map((doc) => 
                  new Text(doc['team_name'])
                ).toList()
              ); 
        } //switch
      } //builder
    ); //StreamBuilder
  } 

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

// This is likely all your InheritedWidget will ever need.
class _InheritedStateContainer extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);
  
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

