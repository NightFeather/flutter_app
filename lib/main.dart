import 'package:flutter/material.dart';
import 'package:flutter_app/random_list.dart';
import 'package:flutter_app/speech_view.dart';
import 'package:flutter_app/side_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(title: 'Random Words'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.plus_one), onPressed: _switchToSpeechView,)
        ],
      ),
      body: Center(
        child: RandomList(),
      ),
      drawer: SideMenu(),
    );
  }

  void _switchToSpeechView() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context){   
          return new Scaffold(
            appBar: new AppBar(
              title: const Text("Meow")
            ),
            body: new SpeechView(),
          );
        }
      )
    );
  }
}
