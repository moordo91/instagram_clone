import 'dart:convert';
import 'store.dart' as store;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var result = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/moordo91/flutter_tutorial/main/data/more.json'));
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
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']),
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('좋아요 ${widget.data[i]['likes']}'),
                      GestureDetector(
                        child: Text(widget.data[i]['user']),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => Profile(),
                                  transitionsBuilder: (c, a1, a2, child) =>
                                      FadeTransition(
                                        opacity: a1,
                                        child: child,
                                      ),
                                  transitionDuration:
                                      Duration(milliseconds: 500)));
                        },
                      ),
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

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Provider.of<store.Store1>(context).name)),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProfileHeader()
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => Image.network(context.watch<store.Store2>().profileImage[i]),
                  childCount: context.watch<store.Store2>().profileImage.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3))
          ],
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('Follower: ${Provider.of<store.Store1>(context).follower}'),
        ElevatedButton(
            onPressed: () {
              context.read<store.Store1>().addFollower();
            },
            child: Text('Follow')),
        ElevatedButton(onPressed: (){
          context.read<store.Store2>().getData();
        }, child: Text('Load'))

      ],
    );
  }
}
