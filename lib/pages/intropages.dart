import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

// Intro Views pages: 
final introPages = [ 
  PageViewModel(
      pageColor: const Color(0xFF03A9F4),
      bubble: Image.asset('assets/stats.png'),
      body: Text(
        "Keep track of your team's goals, assists, and layout D's",
      ),
      title: Text(
        'TAKE STATS',
      ),
      textStyle: TextStyle(fontFamily: "FugazOne", color: Colors.white),
      mainImage: Image.asset(
        'assets/stats.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  PageViewModel(
    pageColor: const Color(0xFFFF8a65),
    iconImageAssetPath: 'assets/twitter-icon.png',
    body: Text(
      'Live tweet with the click of a button',
    ),
    title: Text('TWEET'),
    mainImage: Image.asset(
      'assets/twitter-icon.png',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    textStyle: TextStyle(fontFamily: 'FugazOne', color: Colors.white),
  ),
  PageViewModel(
    pageColor: const Color(0xFFFFb74d),
    iconImageAssetPath: 'assets/hype.png',
    body: Text(
      'Never sacrifice hype for accurate stats again',
    ),
    title: Text('HYPE'),
    mainImage: Image.asset(
      'assets/hype.png',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    textStyle: TextStyle(fontFamily: 'FugazOne', color: Colors.white),
  ),
];


