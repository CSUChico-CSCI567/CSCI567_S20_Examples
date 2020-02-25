import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:geolocator/geolocator.dart';



void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}





class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File _image;
  Position _position;
  List<Placemark> placemark;
  List<int> list;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }


  void _incrementCounter(){
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await Firestore.instance.collection('test').document('u9JWeFMwGZzPp3yvOlGq').get();
      await transaction.update(freshSnap.reference, {
        'count': freshSnap['count'] +1,
      });
    });



  }
  void _decrementCounter(){
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await Firestore.instance.collection('test').document('u9JWeFMwGZzPp3yvOlGq').get();
      await transaction.update(freshSnap.reference, {
        'count': freshSnap['count'] -1,
      });
    });


  }

  void getLocation() async{
     _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
     

//     placemark = await Geolocator().placemarkFromPosition(_position);
    placemark = await Geolocator().placemarkFromCoordinates(52.2165157, 6.9437819);
     for (Placemark place in placemark) {
        print(place.country);
     }

//     print(placemark);
     setState(() {

     });
  }



  @override
  initState() {
    super.initState();
    getLocation();
    list = new List<int>.generate(100, (i) => i + 1);
    // Add listeners to this class
    Firestore.instance
        .collection('test')
        .document('u9JWeFMwGZzPp3yvOlGq')
        .get()
        .then((DocumentSnapshot ds) {
          _counter=ds.data['count'];
          setState(() {

          });
      // use ds as a snapshot
    });


  }

  List<Widget> getChildren(){
    List<Widget> tiles = [];
    for (var i in list) {
      tiles.add(Card( child: ListTile(title: Text(i.toString()),)));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:  Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
             Text(
                'Count:', style: Theme.of(context).textTheme.display1
            ),
            _position == null
                ? Text('No Position.')
                : Text('$_position'),
            placemark == null
            ? Text('No Place.')
            : Container(
              height: 300,
              child: Center(
                child: list==null
                  ? Text("No List")
                  : ListWheelScrollView(
                  children: getChildren(),
                  itemExtent: 100,


                ),
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('test').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text(
                    'Loading Clicks...',
                    style: Theme.of(context).textTheme.display1
                );
                return Text(
                    snapshot.data.documents[0]['count'].toString(),
                    style: Theme.of(context).textTheme.display1
                );
              },
            ),

            Center(
              child: Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _incrementCounter,
                      child: Text(
                          'Increment',
                          style: TextStyle(fontSize: 20)
                      ),
                    ),
                    RaisedButton(
                      onPressed: _decrementCounter,
                      child: Text(
                          'Decrement',
                          style: TextStyle(fontSize: 20)
                      ),
                    )
                  ],
                )
            )
          ],
//              )
        ),


      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter2,
//        tooltip: 'Pick Image',
//        child: Icon(Icons.add),
//      ),
//      comma makes auto-formatting nicer for build methods.
    );
  }
}
