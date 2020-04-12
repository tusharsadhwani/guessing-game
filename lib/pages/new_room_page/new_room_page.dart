import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessing_game/pages/game_page/game_page.dart';

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
    Firestore.instance
        .collection('rooms')
        .add({
          'admin': admin,
          'members': [admin],
        })
        .then((ref) => ref.get())
        .then((doc) {
          print(doc.data);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GamePage(doc.documentID),
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

  generateUserId() => Random().nextInt(100000);
}

class JoinRoom extends StatefulWidget {
  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  var joinRoomForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Room Code",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Your Name",
              ),
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () {},
              child: Text('Join Room'),
            )
          ],
        ),
      ),
    );
  }
}
