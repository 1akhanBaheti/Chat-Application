

import 'dart:io';

import 'package:assignment/Provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GroupName extends StatefulWidget {
  @override
  State<GroupName> createState() => _GroupNameState();
}

class _GroupNameState extends State<GroupName> {
  //const GroupName({Key? key}) : super(key: key);
  var name = TextEditingController();
  var file;
  bool isLoading = false;

  var nameempty = false;

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
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        var file1 = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        //Navigator.pop(context);
                        if (file1 != null) {
                          setState(() {
                            file = file1;
                          });
                        }
                      },
                      child: Stack(
                        children:[ 
                          file==null?Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(50)),
                          child:  Icon(Icons.camera_alt,color:Colors.grey.shade500,),
                        ):Container(),
                        file!=null?Container(
                           decoration: BoxDecoration(
                           
                              borderRadius: BorderRadius.circular(50)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(File(file.path))),
                          height: 60,
                          width: 60,):Container()
                        ]
                      ),
                    ),
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        onChanged: (e) {
                          if (nameempty) {
                            setState(() {
                              nameempty = false;
                            });
                          }
                        },
                        style: GoogleFonts.lato(fontSize: 19),
                        cursorHeight: 25,
                        controller: name,
                        cursorColor: Colors.lightBlue.shade800,
                      ),
                    ))
                  ],
                ),
              ),
              nameempty
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 80, right: 10, top: 5),
                      child: Text(
                        '*Empty',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(top:8),
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
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 2, bottom: 2),
                margin: const EdgeInsets.only(bottom: 20),
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
                    if (name.text.trim() == "") {
                      setState(() {
                        nameempty = true;
                      });
                    } else {
                      await prov.creategroup(name.text,file).then((value) =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              'ChatMainScreen', (route) => false));
                    }
                  },
                ),
              )),
              
        ]),
      ),
    );
  }
}
