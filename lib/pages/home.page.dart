import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title }) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //state variables
  FirebaseAuth _auth = FirebaseAuth.instance; 
  int _selectedIndex = 0;
  FirebaseUser currentUser; 
  String user_name; 
  String image_url; 

  bool notNull(Object o) => o != null;

  void _signOut() async {
    _auth.signOut().then((response) {
      Navigator.of(context).pushReplacementNamed('/login'); 
    });  
  } 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _bottomNavItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')), 
      BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('Roster')), 
      BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile')),  
    ]; 
  } 

  final _pages = [
    Text('Home Page'), //Home 
    Text('Roster page'), //Roster 
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Text(
        // "${user_name}"
        //), 
        //(image_url != null) ? Image.network(image_url) : null, 
        FlatButton(
          child: const Text('Sign out'),
          onPressed: () async {
          //  await _signOut();
          },
        )
      ] //.where(notNull).toList(), 
    ), //Profile
  ]; 

  @override
  initState() {
    super.initState(); 
    _auth.onAuthStateChanged
       .firstWhere((user) => user != null) 
       .then((user) {
          setState(() => {
            this.currentUser = user, 
            this.user_name = user.displayName,
            this.image_url = user.photoUrl 
          }); 
        }); 
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UltiHype"),
        centerTitle: true, 
      ), //appBar 
      body: Center(
        child: _pages.elementAt(_selectedIndex), 
      ), 
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems(),  
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ), //bottomNavigationBar
    ); //Scaffold
  }
}
