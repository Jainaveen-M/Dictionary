import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url="https://owlbot.info/api/v4/dictionary/";
  String _token="USE API KEY HERE";
  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add("notfound");

    }

    _streamController.add("waiting");
    Response response = await get(_url + _controller.text.trim(), headers: {"Authorization": "Token " + _token});
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary"),
        elevation: 10.0,
        backgroundColor: Colors.blue[700],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin:EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce.cancel();
                      _debounce = Timer(Duration(milliseconds: 1000), () {
                        _search();
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search for a word",
                      contentPadding:EdgeInsets.only(left: 25.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: IconButton(
                  iconSize: 40.0,
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _search();
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin:EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Enter word to Search",style:
                TextStyle(
                  fontSize: 20,
                )
                  ,),
              );
            }
            if(snapshot.data == "notfound"){
              return Container(
                child: Text('No results Found'),

              );
            }
            if (snapshot.data == "waiting") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
              return ListView.builder(
                semanticChildCount: 1,
                itemCount: snapshot.data["definitions"].length,
                itemBuilder: (BuildContext context, int index) {
                  if(snapshot.data["definitions"].length == null){
                    return Container();
                  }
                  else{
                    return ListBody(
                      children: <Widget>[
                        Container(
                          color: Colors.grey[300],
                          child: ListTile(
                            leading: snapshot
                                .data["definitions"][index]["image_url"] == null
                                ? null
                                : CircleAvatar(
                              backgroundImage: NetworkImage( snapshot
                                  .data["definitions"][index]["image_url"] ),
                            ),
                            title: Text( _controller.text.trim( ) + "(" +
                                snapshot.data["definitions"][index]["type"] +
                                ")" ),
                          ),
                        ),
                        Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all( 10 ),
                          child: Padding(
                            padding: const EdgeInsets.all( 10.0 ),
                            child: Text(
                              snapshot.data["definitions"][index]["definition"],
                              style: (
                                  TextStyle(
                                    fontSize: 15,
                                  )
                              ), ),
                          ),
                        ),
                        Container(),
                      ],
                    );
                  }
                  },
              );
            }
        ),
      ),
    );
  }
}
