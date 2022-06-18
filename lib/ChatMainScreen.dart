import 'package:assignment/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatMainScreen extends StatefulWidget {
  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  //const ChatMainScreen({Key? key}) : super(key: key);

  // @override
  // void initState() {
  //   Provider.of<provider1>(context).getMessages();
  //   super.initState();
  // }
  bool more = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<provider1>(context);
    //print(FirebaseAuth.instance.currentUser!.uid);
    print("chats=${data.chatKeys.length}");
    print("groupchats=${data.groupkeys.length}");
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.lightBlue.shade800),
          backgroundColor: Colors.lightBlue[800],
          elevation: 0,
          title: const Text('Chats'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('search');
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    more = true;
                  });
                },
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ))
          ],
        ),
        body: Stack(children: [
          FutureBuilder(
            future: data.getMessages(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  data.done) {
                //print("length=${data.chatKeys.length}");
                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (more) {
                      setState(() {
                        more = false;
                      });
                    }
                  },
                  child: ListView.builder(
                      itemCount: data.chatKeys.length + data.groupkeys.length,
                      itemBuilder: (ctx, index) {
                       // print("index=$index");
                       // print((data.chatKeys.length - index).abs());
                        return InkWell(
                          onTap: () {
                            if (more) {
                              setState(() {
                                more = false;
                              });
                            } else {
                              Navigator.of(context)
                                  .pushNamed('chatscreen', arguments: {
                                "key": data.chatKeys.length  > index
                                    ? data.chatKeys[index].toString()
                                    : data
                                        .groupkeys[index-data.chatKeys.length]
                                        .toString(),
                                "type": data.chatKeys.length > index
                                    ? "chat"
                                    : "group",
                                "name": data.chatKeys.length > index
                                    ? data.chats[
                                        data.chatKeys[index].toString()]['name']
                                    : data.groupchats[data
                                        .groupkeys[ index- data.chatKeys.length ]
                                        .toString()]['groupName'],
                                "url": data.chatKeys.length > index
                                    ? data.urls[data.chatKeys[index].toString()]
                                    : data.groupchats[data.groupkeys[
                                       index- data.chatKeys.length]]['url']
                              });
                            }
                          },
                          child: ListTile(
                            leading: Container(
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: data.chatKeys.length > index &&
                                        data.urls[data.chatKeys[index].toString()] !=
                                            null
                                    ? Image.network(data.urls[data.chatKeys[index].toString()])
                                        .image
                                    
                                    :data.chatKeys.length <= index &&data.groupchats[data.groupkeys[index-data.chatKeys.length]]
                                                ['url'] !=
                                            null 
                                        ? Image.network(data.groupchats[data
                                                    .groupkeys[
                                                index-data.chatKeys.length
                                                    ]]['url'])
                                            .image
                                        : null,
                              ),
                            ),
                            title: Text(
                              data.chatKeys.length > index
                                  ? data.chats[data.chatKeys[index].toString()]
                                      ['name']
                                  : data.groupchats[data
                                      .groupkeys[index-data.chatKeys.length]
                                      .toString()]['groupName'],
                              style: GoogleFonts.lato(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              data.chatKeys.length > index
                                  ? data.chatKeys[index].toString()
                                  : ((data.groupchats[data.groupkeys[
                                                  index-data.chatKeys.length ]]
                                              ['userNo']) as List)
                                          .length
                                          .toString() +
                                      " member",
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.lightBlue.shade800,
                      strokeWidth: 1,
                    ),
                  ),
                );
              }
            },
          ),
          more
              ? Positioned(
                  right: 0,
                  //top: 25,
                  child: Card(
                    elevation: 7,
                    child: Container(
                        color: Colors.white,
                        height: 140,
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  more = false;
                                  Navigator.of(context).pushNamed('useredit');
                                });
                              }),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                child: Text(
                                  'Settings',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (() {
                                setState(() {
                                  more = false;
                                  Navigator.of(context).pushNamed('NewGroup');
                                });
                              }),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  'New group',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (() async {
                                await FirebaseAuth.instance.signOut().then(
                                    (value) => Navigator.of(context)
                                        .pushNamed('signup'));
                              }),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Text(
                                  'Logout',
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                )
              : Container(),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      50,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.lightBlue.shade800,
                    ),
                  ),
                )
              : Container()
        ]));
  }
}
