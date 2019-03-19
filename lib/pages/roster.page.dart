import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

class RosterPage extends StatefulWidget {
  @override
  _RosterPageState createState() => new _RosterPageState();
}

class _RosterPageState extends State<RosterPage> {
  AppState appState; 

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return new Builder(builder: (context) {
      return _rosterView;  
    });  
  } //build

  Widget get _rosterView {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 
    var team = appState.activeTeam;  
    var teamName = appState.activeTeamName;  

    return new Scaffold(
        body: Column(
          children: <Widget>[
            Text("${teamName} Roster"), 
            new Expanded(
              child: Builder(builder: (context) {
                return _showPlayers;  
              })  
            ),  
          ], 
        ), //Column
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), 
          onPressed: () async {
            Navigator.of(context).pushNamed("/add_player"); 
          }
        )  
    ); //Scaffold 
  } // _rosterView 

  Widget get _showPlayers {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return StreamBuilder<QuerySnapshot>(
      stream: container.players.where('team', isEqualTo: appState.activeTeam).snapshots(), 
      builder: (BuildContext context, 
                AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            return new ListView(
                children: snapshot.data.documents.map((doc) => 
                  new ListTile(
                      title: new Text(doc['name']), 
                    ) 
                ).toList()
              ); 
        } //switch
      } //builder
    ); //StreamBuilder
  } 
}
