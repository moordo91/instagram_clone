import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.data, this.addData});

  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://raw.githubusercontent.com/moordo91/flutter_tutorial/main/data/more.json'));
    widget.addData(jsonDecode(result.body));
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              children: [
                Image.network(widget.data[i]['image']),
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('좋아요 ${widget.data[i]['likes']}'),
                      Text(widget.data[i]['user']),
                      Text(widget.data[i]['content']),
                    ],
                  ),
                ),
              ],
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}
