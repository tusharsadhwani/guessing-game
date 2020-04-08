import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './pages/home_page/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.grey.shade900,
        primarySwatch: Colors.red,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
        ),
        textTheme: TextTheme(
          display1: GoogleFonts.montserrat(),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
      },
    );
  }
}
