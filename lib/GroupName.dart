import 'package:assignment/Provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GroupName extends StatelessWidget {
  //const GroupName({Key? key}) : super(key: key);

  var name = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<provider1>(context);
    var focus = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue.shade800,
        title: Text(
          'New group',
          style: GoogleFonts.lato(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (!focus.hasPrimaryFocus) focus.unfocus();
        },
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(Icons.camera_alt),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        style: GoogleFonts.lato(fontSize: 19),
                        cursorHeight: 25,
                        controller: name,
                        cursorColor: Colors.lightBlue.shade800,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'Participants : ${prov.grouplist.length}',
                  style: GoogleFonts.lato(
                      fontSize: 19, color: Colors.grey.shade700),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                margin: EdgeInsets.only(bottom: 20),
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: prov.grouplist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber.shade700,
                          ),
                          Text(prov.grouplist[index]['name'])
                        ],
                      );
                    }),
              ),
            ],
          ),
          Positioned(
              bottom: 35,
              right: 15,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  icon: const Icon(
                    Icons.done,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await prov.creategroup(name.text).then((value) =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            'ChatMainScreen', (route) => false));
                  },
                ),
              ))
              
        ]),
      ),
    );
  }
}
