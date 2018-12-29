import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_hour/webview.dart';

class NewPage extends StatefulWidget {
  final String title;
  final String url;
  final String id;

  NewPage(this.title, this.url, this.id);

  @override
  _MyHomePageState createState() => _MyHomePageState(title, url, id);
}

class _MyHomePageState extends State<NewPage> {
  _MyHomePageState(String title, String url, String id);

  List data;

  @override
  void initState() {
    super.initState();
    this.getHeadlines();
  }

  Future<String> getHeadlines() async {
    final String api =
        "https://newsapi.org/v2/top-headlines?sources=${widget.id}&apikey=042457be13e648bdb77d7f01ca5daf0d";

    var response = await http.get(
        // encode the url
        Uri.encodeFull(api),
        // only accept json response
        headers: {"Accept": "Application/json"});

    print(api);

    print("Message is ${response.body}");

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson["articles"];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
                        new WebView(data[index]["title"], data[index]["url"])));
              },
              child: new Card(
                child: new Container(
                  padding: const EdgeInsets.all(5.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Image.network(data[index]["urlToImage"],
                              height: 90.0, width: 95.0, fit: BoxFit.cover),
                          new Expanded(
                              child: new Column(
                            children: <Widget>[
                              new Text(
                                data[index]["title"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              new Container(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: new Text(
                                  data[index]["publishedAt"],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          )),
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
