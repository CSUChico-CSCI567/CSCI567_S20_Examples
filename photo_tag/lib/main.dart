import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_tag/helper.dart';


void main() => runApp(MyApp());

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
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: SecondScreen(title: "Test",),
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
  FixedExtentScrollController scrollController;


  @override
  void initState() {
    scrollController = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget person(AsyncSnapshot<QuerySnapshot> snapshot, index){
    try{
      return Column(
        children: <Widget>[
          ListTile(title: Text(snapshot.data.documents[index]['first'] + " " + snapshot.data.documents[index]['last'])),
          Image.network(
            snapshot.data.documents[index]['downloadURL'], height: 50,
          ),
        ],
      );
    }
    catch(e){
      return ListTile(title: Text(snapshot.data.documents[index]['first'] + " " + snapshot.data.documents[index]['last']));
    }

  }

//  Widget getNames(){
//    return StreamBuilder(
//      stream: Firestore.instance.collection('people').snapshots(),
//      builder: (context, snapshot) {
////        print('Has error: ${snapshot.hasError}');
////        print('Has data: ${snapshot.hasData}');
////        print('Snapshot Data ${snapshot.data}');
//
//        if (snapshot.hasError) {
//          return Text(snapshot.error);
//        }
//        if (!snapshot.hasData) return const Text('Loading People...');
//
//        if (snapshot.hasData) {
//          print('Snapshot Length ${snapshot.data.documents.length}');
//          return Expanded(
//            child:
//            Scrollbar(
//              child: ListView.builder(
//                physics: const AlwaysScrollableScrollPhysics(),
//                itemCount: snapshot.data.documents.length,
//                itemBuilder: (context, index) {
//                  return person(snapshot, index);
//                },
//              ),
//
//            ),
//          );
//        }
//      },
//    );
//  }


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
      body: ListWheelScrollView(
        controller: scrollController,
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 120,
        children: [

         ]
      )

    );
  }
}

class LetterWheel extends StatefulWidget {
  const LetterWheel({Key key}) : super(key: key);

  @override
  _LetterWheelState createState() => _LetterWheelState();
}

class _LetterWheelState extends State<LetterWheel> {
  FixedExtentScrollController scrollController;

  @override
  void initState() {
    scrollController = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      controller: FixedExtentScrollController(),
      physics: const FixedExtentScrollPhysics(),
      itemExtent: 120,
      children: ['A', 'B', 'C', 'D', 'E', 'F', 'G']
          .map(
            (letter) => Container(
          margin: const EdgeInsets.all(10),
          height: 90,
          color: Colors.white,
          child: GestureDetector(
            onTap: () => print('Letter "$letter" is pressed.'),
            child: Center(
              child: Text(
                letter,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}