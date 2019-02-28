import 'package:flutter/material.dart';
import 'loginPage.dart';
void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        // Define the default Brightness and Colors
        primaryColor: Color(0xff03A9F4),
        primaryColorLight: Color(0xff67daff),
        primaryColorDark: Color(0xff007ac1),

        accentColor: Color(0xffFFC107),

        // Define the default Font Family
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: LoginPage(),
    );
  }
}

