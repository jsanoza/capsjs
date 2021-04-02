import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/pages/forchat/chat_screen.dart';
import 'package:get_rekk/pages/forusers/userssched.dart';
import 'package:intl/intl.dart';

import 'chat_archivepage.dart';

class ChatArchive extends StatefulWidget {
  @override
  _ChatArchiveState createState() => _ChatArchiveState();
}

class _ChatArchiveState extends State<ChatArchive> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> memberuid = [];
  String whereto;

  getShop2() {
    User user = auth.currentUser;
    memberuid.add(user.uid.toString());
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("chat_schedule").where('memberuid', arrayContains: user.uid.toString()).snapshots();
    return qn;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: Get.width,
            height: Get.height,
            // color: Colors.white,
            decoration: BoxDecoration(
              gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 66.0),
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: getShop2(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('');
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        return Text('');
                      } else {
                        if (snapshot.data == null) {
                          return Text('');
                        } else {
                          final filteredDocs = snapshot.data.docs.where((doc) => DateTime.now().isAfter(DateFormat('MM-dd-yyyy HH:mm a').parse(doc.data()['endtime']))).toList();
                          return Container(
                            child: ListView.builder(
                              itemCount: filteredDocs.length,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                DateTime myDateTime = filteredDocs[index]["recentmessagetime"].toDate();
                                String formattedTime1 = DateFormat.jm().format(myDateTime);
                                // print(a);
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0, left: 0.0, right: 0.0, top: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.rectangle,
                                            border: Border(
                                              bottom: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
                                            )),
                                        child: ListTile(
                                          leading: Container(
                                            padding: EdgeInsets.only(left: 0.0, right: 0, top: 0),
                                            child: CircleAvatar(
                                              child: Text(filteredDocs[index]["missionname"].toString()[0]),
                                            ),
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              filteredDocs[index]["missionname"].toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito-Regular',
                                              ),
                                            ),
                                          ),
                                          subtitle: Container(
                                            height: 30,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(left: 0.0, top: 0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      AutoSizeText(
                                                        formattedTime1 + "   ",
                                                        minFontSize: 15,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 7.0,
                                                          fontFamily: 'Nunito-Regular',
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          filteredDocs[index]["recentmessagesender"].toString() + ":  " + filteredDocs[index]["recentmessage"].toString(),
                                                          minFontSize: 15,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 7.0,
                                                            fontFamily: 'Nunito-Regular',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: Colors.blue,
                                          ),
                                          onTap: () {
                                            Get.to(ChatArchivePage(
                                              groupname: filteredDocs[index]['missionname'].toString(),
                                              collectionid: filteredDocs[index]['collectionid'].toString(),
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 150.0,
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, size: 25.0),
                            onPressed: () {
                              Get.offAll(ChatScreen(
                                wherefrom: 'archive',
                              ));
                              print('CLicked');
                            },
                          ),
                        ),
                        Text(
                          "Archive Messages",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito-Regular',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Tooltip(
                            message: 'I am a Tooltip',
                            child: IconButton(
                              icon: Icon(Icons.info_outline, size: 25.0),
                              onPressed: () {
                                print('Archived');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
