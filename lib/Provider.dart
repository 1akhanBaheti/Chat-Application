import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

class provider1 extends ChangeNotifier {
  List Users = [];
  var username = {};
  var urls = {};
  Future getusers() async {
    List data = [];

    FirebaseFirestore.instance.collection('Users').snapshots().listen((value) {
      //print(value.docs[0].data());
      Users = [];
      username = {};

      value.docs.forEach((element) {
        //print(element.data());
        //print(element.id);
        var e = {
          "name": element.data()['name'],
          "phoneNo": element.data()['phoneNo'],
          "id": element.id
        };
        username[element.data()['phoneNo'].toString().substring(3)] =
            ReCase(element.data()['name'].toString()).titleCase;
        urls[element.data()['phoneNo'].toString().substring(3)] =
            element['url'];
        //print(urls.toString());
        Users.add(e);
      });
      //print(Users.length);
    });
  }

  Map<String, dynamic> chats = {};
  List chatKeys = [];
  List groupkeys = [];
  Map<String, dynamic> groupchats = {};
  bool done = false;
  Future getMessages() async {
    var instance = FirebaseFirestore.instance
        .collection('Users-Chats')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (!done) {
      await getusers();
      instance.snapshots().listen((event) async {
        print("in");
        if (event.data() != null) {
          await instance.get().then((value) {
            chats = event.data()!['chats'];
            groupchats = event.data()!['group-chats'];
            //print(event.data()!['group-chats']);
            // print(event.data()!['chats']);
            chatKeys = chats.keys.toList();
            groupkeys = groupchats.keys.toList();
            done = true;
            notifyListeners();
          });
        }
      });
    }
    return chats;
  }

  Future sendMessage(
      String m, String key, var id, String name, String type) async {
    print(type);
    if (type == 'chat') {
      var instance = FirebaseFirestore.instance
          .collection('Users-Chats')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var id1 = "";
      //print(Users.length);
      Users.forEach((element) {
        if (element['phoneNo'].toString().substring(3) == key)
          id1 = element['id'];
      });
      //print("id=${id1}");
      var inst = FirebaseFirestore.instance.collection('Users-Chats').doc(id1);
      var data1, data2;

      data1 = chats;
      var internal1 = data1[key] as Map<String, dynamic>?;
      await inst.get().then((value1) => data2 = value1.data()!["chats"]);
      var internal2 =
          data2[FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3)]
              as Map<String, dynamic>?;
      // print(internal);
      if (internal1 == null) {
        internal1 = {};
        internal2 = {};
        internal1.addAll({
          "name": name,
          "id": id1,
        });
        internal2.addAll({
          "name": FirebaseAuth.instance.currentUser!.displayName,
          "id": FirebaseAuth.instance.currentUser!.uid,
        });
      }
      internal1.addAll({
        "${internal1.length - 2 + 1}": {
          "Message": m,
          "Sender":
              FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3),
          "TimeStamp": DateFormat().add_jm().format(DateTime.now()),
        }
      });
      internal2!.addAll({
        "${internal2.length - 2 + 1}": {
          "Message": m,
          "Sender":
              FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3),
          "TimeStamp": DateFormat().add_jm().format(DateTime.now()),
          //"Date":DateFormat('kk:mm a').format(DateTime.now())
        }
      });
      data1[key] = internal1;

      data2[FirebaseAuth.instance.currentUser!.phoneNumber!.substring(3)] =
          internal2;
      await instance.update({"chats": data1}).then((value) async {
        //print(data2);
        await inst.update({"chats": data2});
      });
    } else {
      try {
        var ids = groupchats[key]['usersId'] as List;

        for (int i = 0; i < ids.length; i++) {
          FirebaseFirestore.instance
              .collection("Users-Chats")
              .doc(ids[i])
              .get()
              .then((value) async {
            //print(ids[i]);
            var d = await value.data()!['group-chats'];
            // print(key);
            var d1 = d[key] as Map<String, dynamic>;
            d1.addAll({
              "${d1.length - 4 + 1}": {
                "Message": m,
                "Sender": FirebaseAuth.instance.currentUser!.phoneNumber!
                    .substring(3),
                "TimeStamp": DateFormat().add_jm().format(DateTime.now()),
              }
            });
            d[key] = d1;
            await FirebaseFirestore.instance
                .collection("Users-Chats")
                .doc(ids[i])
                .update({"group-chats": d});
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  var result = [];
  void search(String s) {
    print("length=${Users.length}");
    result = [];

    Users.forEach((value) {
      //print(value.toString());
      if (s != "" && value['phoneNo'].toString().substring(3).startsWith(s)) {
        ReCase r = ReCase(value['name']);
        value['name'] = r.titleCase.toString();
        if (value['phoneNo'] !=
            FirebaseAuth.instance.currentUser!.phoneNumber) {
          result.add(value);
        }
      }
    });
    //print("result="+result.toString());
    // print("grouplist="+grouplist.toString());

    notifyListeners();
  }

  int second = 60;
  void decrement() {
    Future.delayed(const Duration(seconds: 3), () {
      second--;
      notifyListeners();
    });
  }

  var grouplist = [];
  void addtogroup(i) {
    grouplist.add(i);
    notifyListeners();
  }

  void removefromgroup(i) {
    grouplist.removeWhere((element) => element['id'] == i['id']);
    notifyListeners();
  }

  Future creategroup(String name, var file) async {
    var n = [];
    var id = [];
    grouplist.forEach((element) {
      n.add(element['phoneNo']);
      id.add(element['id']);
    });
    n.add(FirebaseAuth.instance.currentUser!.phoneNumber);
    id.add(FirebaseAuth.instance.currentUser!.uid);
    var instance = FirebaseFirestore.instance.collection('Users-Chats');

    var x1 = DateTime.now().toString();
    var link;
    if (file != null) {
      await FirebaseStorage.instance
          .ref('Users')
          .child(x1)
          .child(name)
          .putFile(File(file.path))
          .then((p0) async => link = await p0.ref.getDownloadURL());
    }

    for (int i = 0; i < n.length; i++) {
      try {
        await instance.doc(id[i]).get().then((value) async {
          var data = await value.data()!['group-chats'] as Map<String, dynamic>;
          var s = {};
          s.addAll({"usersId": id, "userNo": n, "groupName": name,"url":link});
          data[x1] = s;
          await instance.doc(id[i]).update({"group-chats": data});
          grouplist = [];
          result = [];
        });
      } catch (e) {
        grouplist = [];
        result = [];
        print(e);
      }
    }
    //print(n.toString());
  }

  Future signup(String email, String text, String text2) async {}
}
