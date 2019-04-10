import 'package:flutter/material.dart';
import 'package:ultihype/main.dart'; 
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:ultihype/pages/edit_player.page.dart'; 

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

  Widget _playerCard(playerSnapshot) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    var player = {
      "id": playerSnapshot.documentID, 
      "firstName": playerSnapshot["firstName"], 
      "lastName": playerSnapshot["lastName"], 
      "nickname": playerSnapshot["nickname"], 
      "height": playerSnapshot["height"], 
      "number": playerSnapshot["number"], 
    };  

    //display variables
    var nickname = player['nickname'] == null ? '' : '"${player['nickname']}"'; 
    var lastName = player['lastName'] == null ? '' : player['lastName']; 
    var number = player['number'] == null ? '' : player['number']; 

    return Card(
      elevation: 4.0, 
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.transparent, 
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.all(const Radius.circular(8.0)),  
            ),
        child: ListTile(

          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), 
          leading: Container(
              padding: EdgeInsets.only(right: 12.0), 
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0))), 
              child: Text(number.isEmpty ? '' : "#${player['number']}", 
                  style: TextStyle(color: Colors.blue, fontSize: 30.0)), 

          ), 
          title: Text(
              '${player['firstName']} ${nickname} ${lastName}', 
              style: TextStyle(
                  color: Colors.black, 
                  fontSize: 22, 
                  fontWeight: FontWeight.bold),  
          ), 
          subtitle: Row(
            children: <Widget>[
              Text(
                  player['height'] ?? ''), 
              //vertical dividing line here
              //show position once it exists
              Text(player["id"]), 
            ],
          ),
          trailing:
            IconButton(
              icon: Icon(Icons.edit), 
              highlightColor: Colors.black, 
              onPressed: () async { 
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => EditPlayerPage(player: player)
                  ), 
                ); 
              }
            ), 
        ) //ListTile
    )); //Container / Card
  } 

  void _onEditButtonPressed() {
    debugPrint("Edit pressed"); 
  } 

  Widget get _rosterView {
    var container = AppStateContainer.of(context); 
    var user = appState.user; 
    var team = appState.activeTeam;  
    var teamName = appState.activeTeamName;  

    return new Scaffold(
        body: Column(
          children: <Widget>[
            //Text("${teamName} Roster"), 
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

  Widget get _emptyRosterView {
    return Center(
        child: Text("Your roster is empty!")
        ); 
  } 

  Widget get _showPlayers {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return StreamBuilder<QuerySnapshot>(
      stream: container.players.where('team', isEqualTo: appState.activeTeam)
                                  .orderBy("firstName").snapshots(), 
      builder: (BuildContext context, 
                AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            var rosterList = snapshot.data.documents.map((doc) => doc).toList(); 
            return rosterList.isEmpty ? _emptyRosterView
                : new ListView.builder(
                itemCount: rosterList.length, 
                itemBuilder: (context, position) {
                  final playerSnapshot = rosterList[position]; 
                  return Dismissible( 
                      background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red, 
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0), 
                            child: Icon(Icons.delete, color: Colors.white,), 
                          ), 
                      ), 
                      key: Key(playerSnapshot.documentID), 
                      direction: DismissDirection.endToStart, 
                      onDismissed: (direction) {
                        container.deletePlayer(playerSnapshot.documentID); 
                       
                        Scaffold
                          .of(context) 
                          .showSnackBar(SnackBar(content:Text("Player deleted"))); 
                      }, //onDismissed 
                      child: _playerCard(playerSnapshot),  
                    ); 
                } //itemBuilder
          ); //ListView.builder 
        } //switch
      } //builder
    ); //StreamBuilder
  } 
}
