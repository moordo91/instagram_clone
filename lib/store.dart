import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class Store1 extends ChangeNotifier {
  var name = 'john kim';
  var follower = 0;
  var followed = false;

  addFollower() {
    if (followed == false) {
      follower++;
      followed = true;
    } else {
      follower--;
      followed = false;
    }
    notifyListeners();
  }

  changeName() {
    name = 'john park';
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var profileImage = [];

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }
}
