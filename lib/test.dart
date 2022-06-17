import 'package:assignment/Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class test extends StatelessWidget {
  const test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<provider1>(context);
    FirebaseFirestore.instance
        .collection('Users-Chats')
        .doc('HHd6YSm2QZCpaH8oxdB6')
        .get()
        .then((value) {
      print(value.data());
    });
    return Scaffold(
      body: Container(),
    );
  }
}
