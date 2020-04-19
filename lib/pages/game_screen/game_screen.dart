import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String roomID;
  GameScreen(this.roomID);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var messages = [];

  void _loadMessages() {
    Firestore.instance
        .collection("rooms")
        .document(widget.roomID)
        .get()
        .then((snapshot) => print(snapshot.data));
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _loadMessages();
  }

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
            child: Row(
              children: <Widget>[
                Expanded(child: TextField()),
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
