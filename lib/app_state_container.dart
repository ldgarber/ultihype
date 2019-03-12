import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
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
    debugPrint('twitterUser: $twitterUser'); 
    if (twitterUser == null) {
      setState(() {
        state.isLoading = false; 
      }); 
    } else {
      var firebaseUser = await logIntoFirebase(); 
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

