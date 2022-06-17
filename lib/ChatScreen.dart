import 'package:assignment/Provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //const ChatScreen({Key? key}) : super(key: key);
  var message = TextEditingController();

  bool isempty = true;

  @override
  Widget build(BuildContext context) {
    var focus = FocusScope.of(context);
    var messages = Provider.of<provider1>(context);
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var url = data['url'];
    var appbar = AppBar(
        backgroundColor: Colors.lightBlue.shade800,
        elevation: 0,
        title: Row(
          children: [
             CircleAvatar(
                radius: 20,
                backgroundColor: Colors.amber,
                backgroundImage:
                // if(url!=null)
                // return CachedNetworkImageProvider();
                // else
                // return null;
                   data['url']!= null ? Image.network(data['url']).image: null
                   
                   ),
            const SizedBox(
              width: 10,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                ReCase(data['name'].toString()).titleCase,
                style:
                    GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));

    //print("data=" + data.toString());
    var key1 = [];
    var keys;
    Map<String, dynamic> m = {};
    if (messages.chats[data['key']] != null) {
      m = messages.chats[data['key']];
    } else if (messages.groupchats[data['key']] != null) {
      m = messages.groupchats[data['key']];
      // print(m.length);
    }

    return Scaffold(
      appBar: appbar,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                appbar.preferredSize.height,
            child: Column(children: [
              Container(
                // height: MediaQuery.of(context).size.height -
                //     MediaQuery.of(context).padding.top -
                //     appbar.preferredSize.height,
                width: MediaQuery.of(context).size.width,
                child: messages.chats[data['key']] != null
                    ? Container(
                        //color: Colors.green,
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            appbar.preferredSize.height -
                            52,
                        child: ListView.builder(
                            itemCount: m.length - 2,
                            itemBuilder: (ctx, index) {
                              // print(index);
                              return GestureDetector(
                                  child: Align(
                                alignment: m[(index + 1).toString()]
                                            ['Sender'] ==
                                        FirebaseAuth
                                            .instance.currentUser!.phoneNumber!
                                            .substring(3)
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child:
                                    Wrap(direction: Axis.vertical, children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: m[(index + 1).toString()]
                                                    ['Sender'] ==
                                                FirebaseAuth.instance
                                                    .currentUser!.phoneNumber!
                                                    .substring(3)
                                            ? Colors.lightGreen[200]
                                            : Colors.yellow[300],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.only(
                                        left: 7, right: 7),
                                    child: Align(
                                      alignment: m[(index + 1).toString()]
                                                  ['Sender'] ==
                                              FirebaseAuth.instance.currentUser!
                                                  .phoneNumber!
                                                  .substring(3)
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Container(
                                            //margin: const EdgeInsets.all(2),
                                            child: Text(
                                              m[(index + 1).toString()]
                                                  ['Message'],
                                              style: GoogleFonts.lato(
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 35, left: 13),
                                              child: Text(
                                                m[(index + 1).toString()]
                                                    ['TimeStamp'],
                                                style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ));
                            }),
                      )
                    : messages.groupchats[data['key']] != null
                        ? Container(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                appbar.preferredSize.height -
                                52,
                            child: ListView.builder(
                                itemCount: m.length - 3,
                                itemBuilder: (ctx, index) {
                                  //print(index);
                                  return GestureDetector(
                                      child: Align(
                                    alignment: m[(index + 1).toString()]
                                                ['Sender'] ==
                                            FirebaseAuth.instance.currentUser!
                                                .phoneNumber!
                                                .substring(3)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: m[(index + 1).toString()]
                                                            ['Sender'] ==
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .phoneNumber!
                                                            .substring(3)
                                                    ? Colors.lightGreen[200]
                                                    : Colors.yellow[300],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: const EdgeInsets.only(
                                                left: 7, right: 7),
                                            child: Align(
                                              alignment:
                                                  m[(index + 1).toString()]
                                                              ['Sender'] ==
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .phoneNumber!
                                                              .substring(3)
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                      messages
                                                          .username[m[(index +
                                                                      1)
                                                                  .toString()]
                                                              ['Sender']
                                                          .toString()],
                                                      style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .deepPurple),
                                                    )),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          //margin: const EdgeInsets.all(2),
                                                          child: Text(
                                                            m[(index + 1)
                                                                    .toString()]
                                                                ['Message'],
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 19,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    left: 13),
                                                            child: Text(
                                                              m[(index + 1)
                                                                      .toString()]
                                                                  ['TimeStamp'],
                                                              style: GoogleFonts.lato(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ]),
                                  ));
                                }),
                          )
                        : Container( height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                appbar.preferredSize.height -
                                52,),
              ),
              Container(
                height: 1.5,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // color: Colors.amber,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: message,
                      onChanged: (value) {},
                      //cursorHeight: 25,
                      cursorColor: Colors.lightBlue.shade800,
                      style: GoogleFonts.lato(
                        fontSize: 19,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              //print(data['id']);
                              //print(data['key']);
                              if (message.text != "") {
                                await messages
                                    .sendMessage(message.text, data['key'],
                                        data['id'], data['name'], data['type'])
                                    .then((value) => message.clear());
                              }
                            },
                            icon: const Icon(
                              Icons.send_rounded,
                            )),
                        border: InputBorder.none,
                        hintText: "Message",
                      ),
                      enabled: true,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
