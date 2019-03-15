import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

class OnboardAddTeamPage extends StatefulWidget {
  @override
  _OnboardAddTeamPageState createState() => new _OnboardAddTeamPageState();
}

class _OnboardAddTeamPageState extends State<OnboardAddTeamPage> {
  AppState appState; 
  final teamNameController = TextEditingController(); 

  @override 
  void dispose() {
    teamNameController.dispose(); 
    super.dispose(); 
  }

  Widget get _addTeamView {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 

    return new Scaffold( 
      appBar: AppBar(
        title: Text("Add a Team"),
      ), //appBar 
      body: Container(
        margin: const EdgeInsets.all(30), 
        padding: const EdgeInsets.all(20), 
        constraints: BoxConstraints.expand(), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: <Widget>[
            Text("What's your team name?", 
                style: TextStyle(fontSize: 22), 
                ), 
            new Container(
              width: 250.0, 
              child: 
                TextField(
                  style: new TextStyle(
                      fontSize: 16.0, 
                  ), 
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                  ),  
                controller: teamNameController, 
              ), //TextField 
            ), 
          ] 
        ), //Column
      ), //Container - body 
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_ios), 
          onPressed: () async {
            container.addTeam(teamNameController.text);   
            container.setOnboardedToTrue(); 
            Navigator.of(context).pushReplacementNamed("/"); 
          }) 
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
