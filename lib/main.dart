import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flippr_covid/Screens/Home.dart';
import 'package:flippr_covid/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: "assets/fliprs.png",
        nextScreen: Home(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: primaryColor,
        pageTransitionType:PageTransitionType.scale,
      ),
    );
  }
}


