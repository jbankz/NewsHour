import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_hour/headlines.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Sources'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;
  final String sources =
      "https://newsapi.org/v2/sources?apikey=042457be13e648bdb77d7f01ca5daf0d";

  Future<String> getSources() async {
    var response = await http.get(
        // encode the url
        Uri.encodeFull(sources),
        // only accept json response
        headers: {"Accept": "Application/json"});

    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson["sources"];
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("NewsHour"),
              accountEmail: new Text("newsapi.org"),
              currentAccountPicture: new CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.red
                        : Colors.white,
                child: new Text("J"),
              ),
            ),
          ],
        ),
      ),
      body: _newsWidget(),
    );
  }

  Widget _newsWidget() {
    return new Container(
      child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new NewPage(data[index]["name"], data[index]["url"],data[index]["id"])));
              },
              child: new Card(
                child: new Container(
                  padding: const EdgeInsets.all(5.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
//                              new Image.network(
//                                  "http://www.ansa.it/sito/img/ico/ansa-144-precomposed.png",
//                                  height: 80.0,
//                                  width: 80.0,
//                                  fit: BoxFit.cover),
                          Image.asset(
                            'assets/news.jpg',
                            height: 80.0,
                            width: 80.0,
                            fit: BoxFit.cover,
                          ),
                          new Expanded(
                            child: new Text(
                              data[index]["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
