import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../game_screen/game_screen.dart';

class LobbyPage extends StatefulWidget {
  static const routeName = '/game';
  final roomID;
  LobbyPage(this.roomID);

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('rooms')
            .document(widget.roomID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              final members = (snapshot.data.data['members'] as List);
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (_, idx) => ListTile(
                        title: Text(members[idx]['name']),
                      ),
                      itemCount: members.length,
                    ),
                  ),
                  RaisedButton(
                    child: Text("Start Game"),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => GameScreen(),
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
