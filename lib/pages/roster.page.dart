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
            var rosterList = snapshot.data.documents.map((doc) => doc).toList(); 
            return new ListView.builder(
                itemCount: rosterList.length, 
                itemBuilder: (context, position) {
                  var doc = rosterList[position]; 
                  var nickname = doc['nickname'] == null ? '' : '"${doc['nickname']}"'; 
                  return Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    color: Colors.transparent, 
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 155, 226, 255), 
                          borderRadius: BorderRadius.all(const Radius.circular(8.0)),  
                          ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), 
                        leading: Container(
                            padding: EdgeInsets.only(right: 12.0), 
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(width: 1.0))), 
                            child: Icon(Icons.directions_run, color: Colors.black), 
                        ), 
                        title: Text(
                            '${doc['firstName']} ${nickname} ${doc['lastName']}', 
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),  
                        ), 
                        subtitle: Row(
                          children: <Widget>[
                            Text(
                                doc['height'] ?? ''), 
                            //vertical dividing line here
                            Text(
                                doc['position'] ?? ''), 
                          ],
                        ),
                        trailing:
                            Text(doc['number'] != null ? "#${doc['number']}" : '', 
                                style: TextStyle(color: Colors.blue, fontSize: 30.0)), 
                      ) //ListTile
                  )); //Container / Card
            } //itemBuilder
          ); //ListView.builder 
        } //switch
      } //builder
    ); //StreamBuilder
  } 
}
