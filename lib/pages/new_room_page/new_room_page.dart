import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessing_game/pages/lobby_page/lobby_page.dart';

class NewRoomPage extends StatefulWidget {
  static const routeName = '/newRoom';

  @override
  _NewRoomPageState createState() => _NewRoomPageState();
}

class _NewRoomPageState extends State<NewRoomPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Room"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                indicator: BoxDecoration(color: Theme.of(context).primaryColor),
                controller: tabController,
                tabs: <Widget>[
                  Tab(text: 'Create'),
                  Tab(text: 'Join'),
                ],
              ),
              Container(
                height: 300,
                child: TabBarView(
                  controller: tabController,
                  children: [CreateRoom(), JoinRoom()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final createRoomForm = GlobalKey<FormState>();
  String adminName;

  void createRoom(context) {
    if (!createRoomForm.currentState.validate()) return;

    createRoomForm.currentState.save();
    final adminId = generateUserId();
    final admin = {
      'name': adminName,
      'id': adminId,
    };
    final roomId = generateRoomId();

    Firestore.instance
        .collection('rooms')
        .add({
          'id': roomId,
          'admin': admin,
          'members': [admin],
          'messages': []
        })
        .then((ref) => ref.get())
        .then((doc) {
          print(doc.data);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => LobbyPage(doc.documentID),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: createRoomForm,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Your Name"),
              validator: (value) {
                if (value.length == 0) return "Enter your name";
                return null;
              },
              onSaved: (value) {
                adminName = value;
              },
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () => createRoom(context),
              child: Text('Create Room'),
            ),
          ],
        ),
      ),
    );
  }
}

class JoinRoom extends StatefulWidget {
  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  var joinRoomForm = GlobalKey<FormState>();
  String userName;
  int roomCode;
  String roomId;

  void joinRoom(context) {
    if (!joinRoomForm.currentState.validate()) return;

    joinRoomForm.currentState.save();
    final userId = generateUserId();
    final user = {
      'name': userName,
      'id': userId,
    };
    final joinMsg = {
      'msgType': 'USER_JOINED',
      'id': userId,
      'name': userName,
    };

    Firestore.instance
        .collection('rooms')
        .where('id', isEqualTo: roomCode)
        .getDocuments()
        .then(
      (snapshot) async {
        if (snapshot.documents.length == 0) {
          showAlert(context, "This room doesn't exist");
        } else {
          roomId = snapshot.documents[0].documentID;
          var roomData = await Firestore.instance
              .collection('rooms')
              .document(roomId)
              .get()
              .then((snapshot) => snapshot.data);

          (roomData['members'] as List).add(user);
          (roomData['messages'] as List).add(joinMsg);

          await Firestore.instance
              .collection('rooms')
              .document(roomId)
              .setData(roomData);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => LobbyPage(roomId),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: joinRoomForm,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Room Code",
              ),
              validator: (value) {
                if (value.length == 0) return "Enter room code";
                var parsedRoomId = int.tryParse(value);
                if (parsedRoomId == null) return "Room code must be a number";
                return null;
              },
              onSaved: (value) {
                roomCode = int.parse(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Your Name",
              ),
              validator: (value) {
                if (value.length == 0) return "Enter your name";
                return null;
              },
              onSaved: (value) {
                userName = value;
              },
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () => joinRoom(context),
              child: Text('Join Room'),
            )
          ],
        ),
      ),
    );
  }
}

int generateUserId() => Random().nextInt(100000);
int generateRoomId() => Random().nextInt(100000000);

void showAlert(BuildContext context, String s) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Error"),
      content: Text(
        s,
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}
