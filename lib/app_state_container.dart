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
  CollectionReference get users => firestore.collection('users'); 
  CollectionReference get teams => firestore.collection('teams'); 
  CollectionReference get players => firestore.collection('players'); 

  DocumentReference get userRef => users.document(state.user.uid);  
  DocumentReference get activeTeamRef => teams.document(state.activeTeam); 

  final twitterLogin = new TwitterLogin(
    consumerKey: 'FxTaSf2ZBGlQ0wwi4Mw2nDv57',
    consumerSecret: 'nRMpbnhHCGfdLyp94BVzO47GzKuutcaTKNsDqys53cEzgMxSzO',
  );

  @override
  void initState() {
    super.initState();
    //get prev state if it exists
    if (widget.state != null) {
      debugPrint("setting state from prev state"); 
      state = widget.state; 
    } else {
      state = new AppState.loading(); 
      initUser().then((_) {
        initActiveTeam(); 
      }); 
    } 
  }

  Future initUser() async {
    await _auth.currentUser().then((firebaseUser) => { 
      setState(() {
        state.user = firebaseUser; 
        state.isLoading = false; 
      })  
    });     
    return; 
  } 

  Future<void> initActiveTeam() async {
    userRef.get().then((docData) {
      if (docData.exists) {
        setState(() {
          state.activeTeam = docData['activeTeam'];  
        }); 
      }  
    });  
    debugPrint("Active team: ${state.activeTeam}"); 
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
        state.user = firebaseUser;
      });

      checkIfNewUserAndInit(); 
    } catch (error) {
      print(error);
      return null;
    }
    setState(() {
      state.isLoading = false; 
    }); 
  } 

  Future<void> checkIfNewUserAndInit() async {
    userRef.get().then((docData) {
      if (docData.exists) {
        initActiveTeam(); 
      } else {
        initNewFirebaseUser(); 
      } 
    }); 
  } 

  Future<void> initNewFirebaseUser() async {
    setState(() { state.onboarded = false; }); 
    await userRef.setData({
      'onboarded': false, 
      'teams': [], 
      'activeTeam': '', 
    });  
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
  
  void setActiveTeam(teamId) {
    userRef.updateData({
      //add team to array of teams on userRef here
      'activeTeam': teamId, 
    }); 
    setState(() => {
      state.activeTeam = teamId,  
    }); 
    debugPrint("active team: ${state.activeTeam}"); 
  } 

  Future<void> addTeam(String team_name) async {
    teams.add({
      'name': team_name, 
      'uid': state.user.uid, 
      'players': [], 
    })
    .then((docRef) {
      //need to add documentID to users teams array also
      setActiveTeam(docRef.documentID); 
    }); 
  } 

  Future<void> addPlayer(Map player) async {
    players.add({
      'firstName': player['firstName'], 
      'lastName': player['lastName'], 
      'height': player['height'], 
      'number': player['number'], 
      'team': state.activeTeam, 
      'uid': state.user.uid
    }).then((result) {debugPrint(result.documentID);}); 
    debugPrint("added player"); 
  } 

  Future<void> updatePlayer(playerID, newPlayer) async {
    players.document(playerID).updateData(
      newPlayer 
    ); 
    debugPrint("updated player"); 
  } 

  Future<void> deletePlayer(String player_id) async {
    try {
      players.document(player_id).delete(); 
    } catch (e) {
      debugPrint(e.toString()); 
    } 
  } 

  Future<String> getActiveTeamName() async {
    activeTeamRef.get().then((data) { 
      return data['name']; 
    });  
  } 

  Future<void> setOnboardedToTrue() async {
    await userRef.setData({'onboarded': true}); 
    setState(() {
      state.onboarded = true; 
    }); 
    debugPrint("onboarded? : ${state.onboarded}"); 
  } 

  StreamBuilder<QuerySnapshot> getTeamNames() {
    return StreamBuilder<QuerySnapshot>(
      stream: teams.snapshots(), 
      builder: (BuildContext context, 
                AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
                children: snapshot.data.documents.map((doc) => 
                  new Text(doc['name'])
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

