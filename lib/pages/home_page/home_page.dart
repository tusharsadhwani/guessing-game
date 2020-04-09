import 'package:flutter/material.dart';
import '../new_room_page/new_room_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: Theme.of(context).textTheme.display1.fontFamily,
      color: Colors.white,
      fontSize: 64.0,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Guessing game"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Guessing',
                style: titleStyle,
              ),
              Text(
                'Game',
                style: titleStyle,
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(NewRoomPage.routeName),
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
