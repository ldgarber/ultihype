import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 

class EditPlayerPage extends StatefulWidget {
  final Map player; 
  const EditPlayerPage({Key key, this.player}) : super(key: key); 

  @override
  _EditPlayerPageState createState() => new _EditPlayerPageState();
}

class _EditPlayerPageState extends State<EditPlayerPage> {
  AppState appState; 

  final firstNameController = TextEditingController(); 
  final lastNameController = TextEditingController(); 
  final nicknameController = TextEditingController(); 
  final heightController = TextEditingController(); 
  final numberController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return new Builder(builder: (context) {
      return _editPlayerView;  
    });  
  } //build

  @override 
  void dispose() {
    firstNameController.dispose(); 
    lastNameController.dispose(); 
    nicknameController.dispose(); 
    heightController.dispose(); 
    numberController.dispose(); 

    super.dispose(); 
  }

  Widget get _editPlayerView {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 
    var team = appState.activeTeam;  

    return new Scaffold( 
      appBar: AppBar(
        title: Text("Edit Player"),
      ), //appBar 
      body: new Container(
        child: _playerInput,   
      )
    ); 
  }  

  Widget get _playerInput {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 
    var team = appState.activeTeam;  

    return Center(
        child: Container(
            width: 250, 
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: <Widget>[
                Text("First Name:", 
                    style: TextStyle(fontSize: 18), 
                    ), 
                TextField(
                  style: new TextStyle(
                      fontSize: 16.0, 
                  ), 
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      hintText: 'First Name', 
                  ),  
                  controller: firstNameController, 
                ), //TextField 
                Text("Last Name:", 
                    style: TextStyle(fontSize: 18), 
                    ), 
                TextField(
                  style: new TextStyle(
                      fontSize: 16.0, 
                  ), 
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      hintText: 'Last Name'
                  ),  
                  controller: lastNameController, 
                ), //TextField 
                Text("Nickname: (optional)", 
                    style: TextStyle(fontSize: 18), 
                    ), 
                TextField(
                  style: new TextStyle(
                      fontSize: 16.0, 
                  ), 
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      hintText: 'Nickname'
                  ),  
                  controller: nicknameController, 
                ), //TextField 

                Text("Number: (optional)", 
                    style: TextStyle(fontSize: 18), 
                    ), 
                TextField(
                  style: new TextStyle(
                      fontSize: 16.0, 
                  ), 
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      hintText: 'Number'
                  ),  
                  keyboardType: TextInputType.number, 
                  controller: numberController, 
                ), //TextField 
                Text("Height: (optional)", 
                    style: TextStyle(fontSize: 18), 
                    ), 
                TextField(
                  style: new TextStyle(
                      fontSize: 16.0, 
                  ), 
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      hintText: 'Height'
                  ),  
                  controller: heightController, 
                ), //TextField 

                RaisedButton (
                  child: const Text('Save'), 
                  onPressed: () => submitPlayer(context), 
                )
              ]) //Column
            ) //Container
          ); // Center
  } //_editPlayerView

  Future<void> submitPlayer(BuildContext context) async {
    var container = AppStateContainer.of(context); 

    if (firstNameController.text.isEmpty) {
      print('First name is required!'); 
    } else if (lastNameController.text.isEmpty) {
      print('Last name is required!'); 
    } else { 
      var newPlayer = {
                      "firstName": firstNameController.text, 
                      "lastName": lastNameController.text, 
                      "nickname": nicknameController.text, 
                      "height": heightController.text, 
                      "number": numberController.text
                    }; 
      container.updatePlayer(widget.player["id"], newPlayer); 
      Navigator.of(context).pop(); 
    } 
  } 

}



