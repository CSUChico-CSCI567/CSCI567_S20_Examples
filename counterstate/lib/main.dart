import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

final String tableTodo = 'count_table';
final String columnId = '_id';
final String columnCount = 'count';

class CountObject {
  int id;
  int count;


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCount: count,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  CountObject();

  CountObject.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    count = map[columnCount];
  }
}

class CountProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnCount integer not null)
''');
        });
  }
//  CountProvider();


  Future<CountObject> insert(CountObject countInstance) async {
    countInstance.id = await db.insert(tableTodo, countInstance.toMap());
    return countInstance;
  }

  Future<CountObject> getCount(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnCount],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return CountObject.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(CountObject todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}

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
  CountProvider cp;

  void _incrementCounter(){
    if (cp == null){
      cp = new CountProvider();
    }
    getCurrentCount().then((CountObject co){
      co.count += 1;
      _counter=co.count;
      if (cp == null){
        cp = new CountProvider();
      }
      cp.update(co);
      setState(() {

      });
    });
  }
  void _decrementCounter(){
    if (cp == null){
      cp = new CountProvider();
    }
    getCurrentCount().then((CountObject co){
      co.count -= 1;
      _counter=co.count;
      if (cp == null){
        cp = new CountProvider();
      }
      cp.update(co);
      setState(() {

      });
    });


  }

  Future<CountObject> getCurrentCount() async{

    await cp.open("mydata.db");
    CountObject co = await cp.getCount(1);
    if(co==null){
      co = new CountObject();
      co.count=0;
      co = await cp.insert(co);
      print(co.id);
      return co;
    }
    return co;

  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    if (cp == null){
      cp = new CountProvider();
    }
    getCurrentCount().then((CountObject value){
      setState(() {
        _counter=value.count;
      });
    });


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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
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
            Text(
              'Count:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
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
      ),
//      comma makes auto-formatting nicer for build methods.
    );
  }
}
