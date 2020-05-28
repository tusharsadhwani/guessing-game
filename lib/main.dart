import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './pages/home_page/home_page.dart';
import './pages/new_room_page/new_room_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey.shade900,
        primarySwatch: Colors.red,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white),
          headline4: GoogleFonts.montserrat(),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        NewRoomPage.routeName: (_) => NewRoomPage(),
      },
    );
  }
}
