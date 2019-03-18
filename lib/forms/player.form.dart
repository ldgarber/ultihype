import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 

class PlayerForm extends StatefulWidget {
  @override
  _PlayerFormState createState() => new _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  AppState appState; 
  final _formKey = GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return new Builder(builder: (context) {
      return _playerForm;  
    });  
  } //build

  Widget get _playerForm {
    return Form(
      key: _formKey, 
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter First Name'; 
              } 
            } 
          ), 
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, we want to show a Snackbar
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ]
      ) //Column 
    );  
  } //_playerForm 

} 
