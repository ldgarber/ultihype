import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  bool isLoading; 
  bool didSeeIntroViews;  
  FirebaseUser user; 
  String activeTeamId; 

  //Constructor
  AppState({ 
    this.isLoading = false, 
    this.didSeeIntroViews = false, 
    this.user, 
    this.activeTeamId = null, 
  }); 

  // A constructor for when the app is loading
  factory AppState.loading() => new AppState(isLoading: true); 

  @override 
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}'; 
  } 
} 
