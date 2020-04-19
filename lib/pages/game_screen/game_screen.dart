import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/message_type.dart';

class GameScreen extends StatefulWidget {
  final String roomId;
  final String memberId;

  GameScreen(this.roomId, this.memberId);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _messageController = TextEditingController(text: '');
  var _buttonEnabled = true;

  String _userName;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('rooms')
        .document(widget.roomId)
        .collection('members')
        .document(widget.memberId)
        .get()
        .then((doc) {
      _userName = doc.data['name'];
    });
  }

  void _sendMessage() async {
    setState(() {
      _buttonEnabled = false;
    });

    final newMessage = {
      'msgType': MessageType.TEXT,
      'name': _userName,
      'text': _messageController.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await Firestore.instance
        .collection('rooms')
        .document(widget.roomId)
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
                  .document(widget.roomId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        switch (document['msgType']) {
                          case MessageType.TEXT:
                            return ListTile(
                              title: Text(document['text']),
                              subtitle: Text(
                                document['name'],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          default:
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(document['msgType']),
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
