import 'package:assignment/Provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class MainSignupLogin extends StatefulWidget {
  //const MainSignupLogin({Key? key}) : super(key: key);

  @override
  State<MainSignupLogin> createState() => _MainSignupLoginState();
}

class _MainSignupLoginState extends State<MainSignupLogin> {
  var phoneNotValid = false;
  var smscode = false;
  var verificationid = "";
  var isLoading = false;
  var nameempty = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.teal.shade400, // status bar color
    ));
    super.initState();
  }

  var email = TextEditingController();
  var code = TextEditingController();
  var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.teal.shade400, // status bar color
    ));
    //print(FirebaseAuth.instance.currentUser!.phoneNumber);
    //FirebaseAuth.instance.currentUser!.phoneNumber;
    var height = MediaQuery.of(context).size.height;
    //var authProvider = Provider.of<Auth>(context);
    var prov = Provider.of<provider1>(context, listen: false);
    var focus = FocusScope.of(context);

    //print('MAINOPTION');

    Future sendcode() async {
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + email.text,
          verificationCompleted: (PhoneAuthCredential p) async {
            try {
              print("completed");
              print(p.verificationId);
              await FirebaseAuth.instance.signInWithCredential(p).then((value) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'ChatMainScreen', (route) => false);
              });
            } catch (e) {
              print(e.toString());
            }
          },
          timeout: Duration(minutes: 2),
          verificationFailed: (FirebaseAuthException e) {
            print(e.message);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message.toString())));
          },
          codeSent: (String verificationId, int? resend) async {
            //print(verificationId);
            setState(() {
              verificationid = verificationId;
              smscode = true;
              isLoading = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: [
        GestureDetector(
            // splashColor: Colors.transparent,
            //highlightColor: Colors.transparent,
            onTap: () {
              if (!focus.hasPrimaryFocus) focus.unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                // alignment: Alignment.bottomCenter,
                height: height,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              left: 23,
                              top: MediaQuery.of(context).padding.top + 30),
                          child: Text(
                            'Verify your phone number',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSans(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 20, top: 20, right: 20),
                          child: Text(
                            'App will send an SMS message to verify your phone number\nEnter your phone number',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSans(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Colors.black.withOpacity(0.2)
                          ),
                          // height: height - height * 0.2,
                          margin: EdgeInsets.only(top: 17, right: 10, left: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.3),
                                    // height: height - height * 0.2,
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 17, right: 10, left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            //color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 20,
                                            bottom: 0),
                                        height: 60,
                                        child: TextFormField(
                                          onChanged: (e) {
                                            if (nameempty) {
                                              setState(() {
                                                nameempty = false;
                                              });
                                            }
                                          },

                                          // maxLength: 10,

                                          controller: name,
                                          cursorColor: Colors.black87,
                                          cursorHeight: 22,
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintStyle: GoogleFonts.lato(
                                              fontSize: 18,
                                            ),
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            hintText: 'Name',
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.teal.shade400,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      nameempty
                                          ? Container(
                                              margin: EdgeInsets.only(left: 20),
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                '*This field required',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.ptSans(
                                                    fontSize: 18,
                                                    color: Colors.red.shade900,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        decoration: BoxDecoration(
                                            //color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 20,
                                            bottom: 10),
                                        height: 60,
                                        child: TextFormField(
                                          onChanged: (e) {
                                            if (phoneNotValid) {
                                              setState(() {
                                                phoneNotValid = false;
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          // maxLength: 10,

                                          controller: email,
                                          cursorColor: Colors.black87,
                                          cursorHeight: 22,
                                          decoration: InputDecoration(
                                            filled: true,
                                            hintStyle: GoogleFonts.lato(
                                              fontSize: 18,
                                            ),
                                            prefixIcon: Container(
                                                height: 60,
                                                width: 70,
                                                //margin: EdgeInsets.only(left: 5),
                                                alignment: Alignment.center,
                                                child: Text("+91",
                                                    style: GoogleFonts.lato(
                                                      fontSize: 18,
                                                    ))),
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            hintText: 'phone number',
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.teal.shade400,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      phoneNotValid
                                          ? Container(
                                              margin: EdgeInsets.only(left: 20),
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Text(
                                                '* Invalid',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.ptSans(
                                                    fontSize: 18,
                                                    color: Colors.red.shade900,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                            ),
                                      smscode
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  //color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: double.infinity,
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 20),
                                              height: 60,
                                              child: TextFormField(
                                                controller: code,
                                                onChanged: (e) {},
                                                keyboardType:
                                                    TextInputType.number,
                                                // maxLength: 10,                                controller: code,
                                                cursorColor: Colors.black87,
                                                cursorHeight: 22,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    hintStyle: GoogleFonts.lato(
                                                      fontSize: 18,
                                                    ),
                                                    fillColor: Colors.white,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    hintText: 'code',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .teal
                                                                        .shade400,
                                                                    width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    suffixIcon:
                                                        Consumer<provider1>(
                                                            builder: (a, b, c) {
                                                      if (b.second > 0)
                                                        b.decrement();
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          if (b.second <= 0) {
                                                            print("called");
                                                            setState(() {
                                                              prov.second = 60;
                                                            });

                                                            await sendcode();
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 80,
                                                          alignment:
                                                              Alignment.center,
                                                          height: 60,
                                                          child: b.second > 0
                                                              ? Text(
                                                                  'resend(${b.second}s)',
                                                                  style: GoogleFonts.lato(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                      fontSize:
                                                                          14),
                                                                )
                                                              : Text(
                                                                  'resend',
                                                                  style: GoogleFonts.lato(
                                                                      color: Colors
                                                                          .teal,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                        ),
                                                      );
                                                    })),
                                              ),
                                            )
                                          : Container(),
                                      InkWell(
                                        onTap: () async {
                                          if (email.text.length > 10 ||
                                              num.tryParse(email.text) ==
                                                  null ||
                                              email.text.length < 10 ||
                                              name.text == "") {
                                            setState(() {
                                              phoneNotValid = true;
                                              nameempty = true;
                                            });
                                          } else {
                                            if (smscode) {
                                              // print("lakhan");
                                              String sms = code.text;
                                              //print(verificationid);
                                              PhoneAuthCredential credential =
                                                  PhoneAuthProvider.credential(
                                                      verificationId:
                                                          verificationid,
                                                      smsCode: sms);
                                              try {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                await FirebaseAuth.instance
                                                    .signInWithCredential(
                                                        credential)
                                                    .then((value) async {
                                                  if (FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .displayName ==
                                                      null) {
                                                    print("setter");
                                                    await FirebaseAuth
                                                        .instance.currentUser!
                                                        .updateDisplayName(
                                                            ReCase(name.text)
                                                                .titleCase)
                                                        .then((value) async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        "name": FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .displayName,
                                                        "phoneNo": FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .phoneNumber,
                                                            "url":null
                                                      });
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Users-Chats')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        "chats": {},
                                                        "group-chats": {},
                                                      }).then((value) {
                                                        prov.second = 60;
                                                        Navigator.of(context)
                                                            .pushNamedAndRemoveUntil(
                                                                'ChatMainScreen',
                                                                (route) =>
                                                                    false);
                                                      });
                                                    });
                                                  } else {
                                                    print("nooo");
                                                    prov.second = 60;
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            'ChatMainScreen',
                                                            (route) => false);
                                                  }
                                                });
                                              } catch (e) {
                                                setState(() {
                                                  prov.second = 10;
                                                  isLoading = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          duration: Duration(
                                                              seconds: 4),
                                                          content: Text(
                                                              e.toString())));
                                                });

                                                print(e);
                                              }
                                            } else {
                                              setState(() {
                                                smscode = true;
                                                isLoading = true;
                                              });
                                              await sendcode();
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 60,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.teal.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              'continue',
                                              style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ]),
                ),
              ),
            )),
        //  Container(
        //   margin: EdgeInsets.only(
        //       top: 15, left: MediaQuery.of(context).size.width - 50),
        //   child: TextButton(
        //       onPressed: () {
        //         Navigator.of(context)
        //             .pushNamedAndRemoveUntil('toMainScreen', (route) => false);
        //       },
        //       child: Text('Skip',style: TextStyle(color: Colors.teal.shade400),)),
        // ),
        isLoading
            ? Container(
                color: Colors.white.withOpacity(0.3),
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                  color: Colors.teal.shade400,
                )),
              )
            : Container()
      ]),
    );
  }
}
