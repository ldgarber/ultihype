import 'package:flutter/material.dart';
import 'package:ultihype/main.dart';
import 'package:ultihype/app_state_container.dart'; 
import 'package:ultihype/models/app_state.dart'; 
import 'package:ultihype/pages/login.page.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppState appState; 

  //state variables
  int _selectedIndex = 0;

  bool notNull(Object o) => o != null;

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

  Widget get _loadingView {
    return new Center(
        child: new CircularProgressIndicator(), 
        ); 
  } 

  Widget get _homeView {
    var container = AppStateContainer.of(context); 

    var _pages = [
      Text('Home Page'), //Home 
      Text('Roster page'), //Roster 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            appState.toString()  
          ), 
          //(image_url != null) ? Image.network(image_url) : null, 
          FlatButton(
            child: const Text('Sign out'),
            onPressed: () async {
              container.signOut(); 
            },
          )
        ] //.where(notNull).toList(), 
      ), //Profile
    ]; 

    return new Scaffold( 
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
    ); 
  } //_homeView

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView; 
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginPage();  
    } else {
      return Builder(builder: (context) {
        return _homeView; 
      }); 
    } 
  } //_pageToDisplay 

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context); 
    appState = container.state; 

    return new Builder(builder: (context) {
      return _pageToDisplay; 
    });  
  } //build

} 
