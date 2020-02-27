import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
      child: ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Navigation is Awesome'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              if(Navigator.canPop(context)){
                Navigator.of(context).pop();
              }
// Update the state of the app.
// ...
            },
          ),
          ListTile(
            title: Text('Account'),
            onTap: () {
// Update the state of the app.
// ...
            },
          ),
        ],
      ),
    );
  }
}
