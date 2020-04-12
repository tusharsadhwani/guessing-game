import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  static const routeName = '/game';
  final roomID;
  GamePage(this.roomID);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Future getGameData() async {
    var snapshot = await Firestore.instance
        .collection('rooms')
        .document(widget.roomID)
        .get();

    return snapshot.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game"),
      ),
      body: FutureBuilder(
        future: getGameData(),
        builder: (ctx, snapshot) => Container(
          child: Text(snapshot.data?.toString() ?? 'loading'),
        ),
      ),
    );
  }
}
