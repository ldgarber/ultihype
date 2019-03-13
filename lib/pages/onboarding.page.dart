import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:ultihype/models/app_state.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/pages/home.page.dart'; 

class OnboardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _OnboardingPageState(); 
} 

class _OnboardingPageState extends State<OnboardingPage> {
  AppState appState; 
  final teamNameController = TextEditingController(); 

  @override 
  void dispose() {
    teamNameController.dispose(); 
    super.dispose(); 
  }

  Widget get _onboarding {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 

    return new Builder( 
        builder: (context) => 
        //page contents 
          Scaffold( 
              appBar: AppBar(
              title: Text("CREATE A TEAM"),
              centerTitle: true, 
            ), //appBar 
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: <Widget>[
                  Text("Team Name:"), 
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
                            hintText: 'Team Name'
                        ),  
                      controller: teamNameController, 
                    ), //TextField 
                  ), 
                  RaisedButton (
                    child: const Text('Save'), 
                    onPressed: () async {
                      container.addTeam(teamNameController.text);   
                    }
                  ), 
                  Text("Teams"), 
                  new Expanded(
                    child: container.getTeamNames()  
                  ) 
                ] 
              ), //Column
            ), //Center 
          )  //Scaffold
    ); //Builder
  }
  
  @override
  Widget build(BuildContext context) {     
    final container = AppStateContainer.of(context); 
    appState = container.state; 

    var width = MediaQuery.of(context).size.width; 

    return new Builder(
      builder: (context) => 
        _onboarding 
    );  
  } //build 

} 
