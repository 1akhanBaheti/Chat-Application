import 'package:assignment/Provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<provider1>(context);
    data.getusers();
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 35),
              child: Row(
                children: [
                  Container(
                      //color: Colors.amber,
                      //margin: const EdgeInsets.only(left: 10),
                      child: IconButton(
                          onPressed: () {
                            data.result = [];
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.grey.shade600,
                            size: 26,
                          ))),
                  Expanded(
                      child: Container(
                    // color: Colors.amber,
                    //height: 50,

                    margin: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      onChanged: (value) {
                        data.search(value);
                      },
                      //cursorHeight: 25,
                      cursorColor: Colors.lightBlue.shade800,
                      style: GoogleFonts.lato(
                        fontSize: 19,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                      ),
                      enabled: true,
                    ),
                  )),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
            Container(
              // color: Colors.amber,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.result.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('chatscreen',
                              arguments: {
                                "type":"chat",
                                "name":data.result[index]['name'],
                                 "key":data.result[index]['phoneNo'].toString().substring(3),
                                 "id":data.result[index]['id']
                                //"Message":data.chats[data.result[index]]['name']
                              });
                        },
                        child: ListTile(
                          leading: Container(
                            child: const CircleAvatar(
                              radius: 25,
                            ),
                          ),
                          title: Text(
                            data.result[index]['phoneNo'].toString(),
                            style: GoogleFonts.lato(fontSize: 20),
                          ),
                          subtitle: Text(
                            data.result[index]['name'].toString(),
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
