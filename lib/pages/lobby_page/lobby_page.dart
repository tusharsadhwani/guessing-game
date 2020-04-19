import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../game_screen/game_screen.dart';

class LobbyPage extends StatefulWidget {
  final String roomId;
  final String memberId;
  LobbyPage(this.roomId, this.memberId);

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  Future<Map<String, dynamic>> _loadRoomData() async {
    final DocumentSnapshot doc = await Firestore.instance
        .collection('rooms')
        .document(widget.roomId)
        .get();
    final Stream<QuerySnapshot> members = Firestore.instance
        .collection("rooms")
        .document(doc.documentID)
        .collection("members")
        .snapshots();
    return {'code': doc.data['code'], 'members': members};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadRoomData(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              final int roomCode = snapshot.data['code'];
              final Stream<QuerySnapshot> members = snapshot.data['members'];
              return StreamBuilder<QuerySnapshot>(
                stream: members,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading...');
                    default:
                      final List members = snapshot.data.documents;
                      return Column(
                        children: [
                          ListTile(
                            title: Text("Room Code: $roomCode"),
                          ),
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
                            onPressed: () =>
                                Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) =>
                                    GameScreen(widget.roomId, widget.memberId),
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                },
              );
          }
        },
      ),
    );
  }
}
