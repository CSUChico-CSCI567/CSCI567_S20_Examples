import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List<Widget> makeList(){
    return [
      Text('Hello'),
      Image(
        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      ),
      RaisedButton(
        onPressed: null,
        child: Text(
          'Disabled Button',
          style: TextStyle(fontSize: 20)
         ),
      ),
//      SizedBox(height: 30),
      RaisedButton(
        onPressed: () {},
        child: const Text(
            'Enabled Button',
            style: TextStyle(fontSize: 20)
          ),
      ),
    ];
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Simple App"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: makeList()
            ),
          ),
        )
    );
  }
}
