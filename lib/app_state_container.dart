import 'package:ultihype/models/app_state.dart'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart'; 

class AppStateContainer extends StatefulWidget {
  final AppState state; 

  //this widget is the root of the tree
  final Widget child; 

  AppStateContainer({
    @required this.child, 
    this.state, 
  }); 

  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) 
            as _InheritedStateContainer).data; 
  }

  @override 
  _AppStateContainerState createState() => new _AppStateContainerState(); 
} 

class AppStateContainerState extends State<StateContainer> {
  AppState state; 

  @override
  void initState() {
    super.initState(); 
  } 

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this, 
      child: widget.child, 
    ); 
  } 
} 

// The Inherited Widget
class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data; 

  _InheritedStateContainer({
    Key key, 
    @required this.data, 
    @required Widget child, 
  }) : super(key: key, child: child); 

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true
} 


