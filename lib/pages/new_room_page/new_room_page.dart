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

class CreateRoom extends StatelessWidget {
  void createRoom(context) {
    Firestore.instance
        .collection('rooms')
        .add({'admin': 12345, 'members': []})
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
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Your Name"),
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

class JoinRoom extends StatelessWidget {
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
