import 'package:flutter/material.dart';
import 'package:ultihype/app.dart'; 
import 'package:ultihype/app_state_container.dart'; 

void main() {
  runApp(new AppStateContainer(
    child: new AppRootWidget(), 
  )); 
}
