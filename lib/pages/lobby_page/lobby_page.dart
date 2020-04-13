import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LobbyPage extends StatefulWidget {
  static const routeName = '/game';
  final roomID;
  LobbyPage(this.roomID);

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
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
        title: Text("Lobby"),
      ),
      body: FutureBuilder(
          future: getGameData(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final members =
                  ((snapshot.data as Map<String, dynamic>)['members'] as List);

              return ListView.builder(
                itemBuilder: (_, idx) => ListTile(
                  title: Text(members[idx]['name']),
                ),
                itemCount: members.length,
              );
            } else {
              return Text('loading');
            }
          }),
    );
  }
}
