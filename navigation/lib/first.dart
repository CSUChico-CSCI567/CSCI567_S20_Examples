import 'package:flutter/material.dart';
import 'package:navigation/drawer.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen when tapped.
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}