import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/message_type.dart';

class GameScreen extends StatefulWidget {
  final String roomID;
  GameScreen(this.roomID);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _messageController = TextEditingController(text: '');
  var _buttonEnabled = true;

  void _sendMessage() async {
    setState(() {
      _buttonEnabled = false;
    });

    final newMessage = {
      'msgType': MessageType.TEXT,
      'text': _messageController.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await Firestore.instance
        .collection('rooms')
        .document(widget.roomID)
        .collection('messages')
        .add(newMessage);

    setState(() {
      _buttonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Room"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('rooms')
                  .document(widget.roomID)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        switch (document['msgType']) {
                          case MessageType.TEXT:
                            return new ListTile(
                              title: new Text(document['text']),
                              subtitle: new Text(document['msgType']),
                            );
                          default:
                            return new ListTile(
                              title: new Text(document['name']),
                              subtitle: new Text(document['msgType']),
                            );
                        }
                      }).toList(),
                    );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withAlpha(60),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                  ),
                ),
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.send),
                  onPressed: _buttonEnabled ? _sendMessage : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
