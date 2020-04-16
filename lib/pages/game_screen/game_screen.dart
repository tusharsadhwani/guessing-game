import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Room"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ListView()),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withAlpha(60),
            child: TextField(),
          ),
        ],
      ),
    );
  }
}
