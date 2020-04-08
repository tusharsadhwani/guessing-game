import 'package:flutter/material.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
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
                children: [
                  Text('hi'),
                  Icon(Icons.directions_transit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
