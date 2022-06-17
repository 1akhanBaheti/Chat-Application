import 'dart:io';

import 'package:assignment/Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoEdit extends StatefulWidget {
  //UserInfoEdit({Key? key}) : super(key: key);

  @override
  _UserInfoEditState createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {
  var file;
  //var name = TextEditingController();

  var name = TextEditingController.fromValue(TextEditingValue(
      text: FirebaseAuth.instance.currentUser!.displayName!,
      selection: TextSelection.fromPosition(
        TextPosition(
            offset: FirebaseAuth.instance.currentUser!.displayName!.length),
      )));
  var phoneNo = TextEditingController();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.displayName!);
    //print(FirebaseAuth.instance.currentUser!.photoURL);
    //name.text = FirebaseAuth.instance.currentUser!.displayName!;
    // name.value = TextEditingValue(
    //     text: FirebaseAuth.instance.currentUser!.displayName!,
    //     selection: TextSelection.fromPosition(
    //       TextPosition(
    //           offset: FirebaseAuth.instance.currentUser!.displayName!.length),
    //     ));
    var focus = FocusScope.of(context);
    var prov = Provider.of<provider1>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
            //splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            onTap: () {
              if (!focus.hasPrimaryFocus) focus.unfocus();
            },
            child: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.black,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            child: Text(
                              'Info',
                              style: GoogleFonts.lato(
                                  color: Colors.black, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Stack(
                        children: [
                          Center(
                            child: CircleAvatar(
                                backgroundImage: file != null
                                    ? FileImage(File(file.path))
                                    : FirebaseAuth.instance.currentUser!
                                                .photoURL !=
                                            null
                                        ? Image.network(FirebaseAuth.instance
                                                .currentUser!.photoURL!)
                                            .image
                                        : null,
                                radius: 75,
                                backgroundColor: Colors.grey.shade400,
                                child: isLoading
                                    ? Shimmer.fromColors(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(90)),
                                        ),
                                        baseColor: Colors.grey.shade400,
                                        highlightColor: Colors.grey.shade300)
                                    : Container()),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 100,
                                left: MediaQuery.of(context).size.width * .50 +
                                    20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              elevation: 10,
                              child: IconButton(
                                onPressed: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (ctx) {
                                        return Container(
                                            height: 100,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      var file1 = await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      Navigator.pop(context);
                                                      if (file1 != null) {
                                                        setState(() {
                                                          file = file1;
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      // color: Colors.amber,
                                                      decoration: BoxDecoration(
                                                          border: BorderDirectional(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                  width: 2))),
                                                      height: 50,
                                                      padding: EdgeInsets.only(
                                                          left: 10, top: 10),
                                                      child: Text(
                                                        'Pick From Gallery',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        file = null;
                                                      });
                                                    },
                                                    child: Container(
                                                      // margin: EdgeInsets.only(left:10,top: 5),
                                                      padding: EdgeInsets.only(
                                                          left: 10, top: 10),
                                                      height: 50,

                                                      child: Text(
                                                        'remove',
                                                        style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  )
                                                ]));
                                      });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Name',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 4),
                      child: TextFormField(
                        //initialValue: FirebaseAuth.instance.currentUser!.displayName,
                        controller: name,
                        cursorColor: Colors.deepPurple,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 2),
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Phone no',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 10),
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade400)),
                        child: Text(
                          FirebaseAuth.instance.currentUser!.phoneNumber!,
                          style: GoogleFonts.lato(
                            fontSize: 18,
                          ),
                        )),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        if (file == null &&
                            FirebaseAuth.instance.currentUser!.displayName ==
                                name.text.trim()) {
                          // Navigator.of(context)
                          //     .pushNamedAndRemoveUntil('', (route) => false);
                        } else if (file != null) {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await FirebaseStorage.instance
                                .ref('Users')
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child(FirebaseAuth
                                    .instance.currentUser!.displayName!)
                                .putFile(File(file.path))
                                .then((p0) async {
                              await FirebaseAuth.instance.currentUser!
                                  .updatePhotoURL(await p0.ref.getDownloadURL())
                                  .then((value) async {
                                await FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  "name": FirebaseAuth
                                      .instance.currentUser!.displayName,
                                  "phoneNo": FirebaseAuth
                                      .instance.currentUser!.phoneNumber,
                                  "url": FirebaseAuth
                                      .instance.currentUser!.photoURL,
                                });
                                setState(() {
                                  file = null;
                                  isLoading = false;
                                });
                              });
                            });
                          } catch (e) {
                            print(e);
                          }
                        }
                        if (FirebaseAuth.instance.currentUser!.displayName !=
                            name.text.trim()) {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await FirebaseAuth.instance.currentUser!
                                .updateDisplayName(name.text.trim())
                                .then((value) async {
                              var instance = FirebaseFirestore.instance
                                  .collection("Users-Chats");
                              for (int i = 0; i < prov.chatKeys.length; i++) {
                                await instance
                                    .doc(prov.chats[prov.chatKeys[i]]['id'])
                                    .get()
                                    .then((value) async {
                                  var d = await value.data()!['chats'];
                                  d[FirebaseAuth
                                          .instance.currentUser!.phoneNumber!
                                          .toString()
                                          .substring(3)]['name'] =
                                      FirebaseAuth
                                          .instance.currentUser!.displayName!
                                          .toString();
                                  await instance
                                      .doc(prov.chats[prov.chatKeys[i]]['id'])
                                      .update({"chats": d});
                                });
                              }
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "name": FirebaseAuth
                                    .instance.currentUser!.displayName!
                                    .toString()
                              }).then((value) {
                                setState(() {
                              isLoading = false;
                            });
                              });
                            });
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print(e);
                          }
                        }
                      },
                      child: Container(
                        color: Colors.deepPurple,
                        height: 50,
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          'Save',
                          style: GoogleFonts.ptSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          color: Colors.deepPurple,
                        ),
                      ),
                    )
                  : Container(),
            ])),
      ),
    );
  }
}
