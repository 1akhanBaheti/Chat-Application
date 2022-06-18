import 'package:assignment/Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewGroup extends StatelessWidget {
  // const NewGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<provider1>(
      context,
    );
    var focus = FocusScope.of(context);
    //print(data.result.length);
    data.getusers();

    bool find(result) {
      bool i = false;
      data.grouplist.forEach((element) {
        if (result['id'] == element['id']) {
          i = true;
        }
      });
      if (i) return true;
      return false;
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          print("wilpopup");
          data.grouplist = [];
          data.result = [];
          return true;
        },
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (!focus.hasPrimaryFocus) focus.unfocus();
          },
          child: Container(
            //color: Colors.green,

            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Column(
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
                                  data.grouplist = [];
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.grey.shade600,
                                  size: 26,
                                ))),
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: TextFormField(
                            onChanged: (value) {
                              // print("aa");
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
                  data.grouplist.isEmpty
                      ? Container()
                      : Consumer<provider1>(
                          builder: (a, b, c) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 2, bottom: 2),
                              margin: const EdgeInsets.only(bottom: 20),
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: b.grouplist.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    return Stack(children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                Colors.amber.shade700,
                                          ),
                                          Text(b.grouplist[index]['name'])
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () => data.removefromgroup(
                                            data.grouplist[index]),
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.red.shade900,
                                          ),
                                        ),
                                      )
                                    ]);
                                  }),
                            );
                          },
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
                                if (find(data.result[index])) {
                                  print('if');
                                  data.removefromgroup(data.result[index]);
                                } else {
                                  print('else');
                                  data.addtogroup(data.result[index]);
                                }
                              },
                              child: ListTile(
                                leading: find(data.result[index])
                                    ? Container(
                                        child: const CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.green,
                                            child: Icon(Icons.done)),
                                      )
                                    : Container(
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
              data.grouplist.isNotEmpty
                  ? Positioned(
                      bottom: 15,
                      right: 15,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(50)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('GroupName');
                          },
                        ),
                      ))
                  : Container()
            ]),
          ),
        ),
      ),
    );
  }
}
