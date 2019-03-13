import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

class AddTeamPage extends StatefulWidget {
  @override
  _AddTeamPageState createState() => new _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  AppState appState; 

  Widget get _addTeamView {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 

    return new Scaffold( 
      appBar: AppBar(
        title: Text("Add a Team"),
      ), //appBar 
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              FlatButton (
                child: const Text('Add Team'), 
                onPressed: () async {
                  container.addTeam();   
                }), 
              Text("Teams"), 
              new Expanded(
                child: container.getTeamNames()  
              ) 
            ] 
          ), //Column
        ), 
    ); //Scaffold 
  } //_addTeamView

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return new Builder(builder: (context) {
      return _addTeamView;  
    });  
  } //build

}
