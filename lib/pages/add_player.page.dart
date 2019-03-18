import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

class AddPlayerPage extends StatefulWidget {
  @override
  _AddPlayerPageState createState() => new _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  AppState appState; 
  final _formKey = GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return new Builder(builder: (context) {
      return _addPlayerView;  
    });  
  } //build

  Widget get _addPlayerView {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 
    var team = appState.activeTeam;  

    final nameController = TextEditingController(); 

    @override 
    void dispose() {
      nameController.dispose(); 
      super.dispose(); 
    }

    return new Scaffold( 
      appBar: AppBar(
        title: Text("Add a Player"),
      ), //appBar 
      body: new Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              Text("Name:", 
                  style: TextStyle(fontSize: 18), 
                  ), 
              new Container(
                width: 250.0, 
                child: 
                  TextField(
                    style: new TextStyle(
                        fontSize: 16.0, 
                    ), 
                    maxLength: 30, 
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), 
                        hintText: 'First Name'
                    ),  
                  controller: nameController, 
                ), //TextField 
              ), 
              RaisedButton (
                child: const Text('Save'), 
                onPressed: () async {
                  container.addPlayer(nameController.text);   
                  Navigator.of(context).pop(); 
                }), 
            ] 
          ), //Column
        ), //Container
    ); //Scaffold 
  } //_addPlayerView

}
