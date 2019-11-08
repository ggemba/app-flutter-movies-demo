import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const api = "https://prd-movies-api.herokuapp.com/api/v1/movies/count?title=";

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listMovies; //= ["Year: 2016 Filmes: 10"];
  final _nameFilmControler = TextEditingController();
  String totalCount = "";

  void _requestApi(name) async {
    var response = await  http.get(Uri.encodeFull(api + name));

    setState(() {
      var object = json.decode(response.body);
      totalCount = "TOTAL: " + object["total"].toString();
      _listMovies = object["moviesByYear"];
    });
  }

  void _searchFilm (){
    _requestApi(_nameFilmControler.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmes por ano"),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _nameFilmControler,
                      decoration: InputDecoration(
                          labelText: "Nome do filme",
                          labelStyle: TextStyle(color: Colors.deepOrangeAccent)
                      ),
                    )
                ),
                RaisedButton(
                  color: Colors.deepOrangeAccent,
                  child: Text("BUSCAR"),
                  textColor: Colors.white,
                  onPressed: _searchFilm,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 5.0),
              itemCount: _listMovies == null ? 0 : _listMovies.length,
              itemBuilder: (BuildContext context, i){
                return new ListTile(
                  title: new Text("Year: " + _listMovies[i]["year"]),
                  subtitle: new Text("Movies: " + _listMovies[i]["movies"].toString()),
                );
              }
            ),
          ),
          Text(totalCount,
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 15.0),
          )
        ],
      )
    );
  }
}

