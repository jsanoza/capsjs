import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/pages/foradmin/fourth.dart';
import 'package:get_rekk/pages/forchat/chat_archive.dart';
import 'package:get_rekk/pages/forchat/chat_page.dart';
import 'package:get_rekk/pages/forusers/userssched.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String wherefrom;

  const ChatScreen({Key key, this.wherefrom}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> memberuid = [];
  String whereto;
  String post;
  String email;

  getShop2() {
    User user = auth.currentUser;
    memberuid.add(user.uid.toString());
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("chat_schedule").where('memberuid', arrayContains: user.uid.toString()).snapshots();
    return qn;
  }

  getPost() async {
    QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid.toString()).get();
    username.docs.forEach((document) {
      email = document.data()['email'];
    });
    setState(() {
      check();
    });
  }

  check() async {
    QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('userlevel').where('email', isEqualTo: email).get();
    usernamex.docs.forEach((document) {
      post = document.data()['level'];
    });
    setState(() {
      print(email + post);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPost();
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
                          final filteredDocs = snapshot.data.docs.where((doc) => DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['endtime']).isAfter(DateTime.now())).toList();

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
                                            child: AutoSizeText(
                                              filteredDocs[index]["missionname"].toString(),
                                              maxFontSize: 16,
                                              minFontSize: 16,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                            Get.to(ChatPage(
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
                              if (widget.wherefrom == 'dash' && post == 'user') {
                                Get.offAll(UsersSched());
                              } else if (widget.wherefrom == 'admindash' && post == 'admin') {
                                Get.offAll(Fourth());
                              } else if (widget.wherefrom == 'archive' && post == 'user') {
                                Get.offAll(UsersSched());
                              } else if (widget.wherefrom == 'archive' && post == 'admin') {
                                Get.offAll(Fourth());
                              } else if (widget.wherefrom == 'page' && post == 'user') {
                                Get.offAll(UsersSched());
                              } else if (widget.wherefrom == 'page' && post == 'admin') {
                                Get.offAll(Fourth());
                              }
                              print('CLicked');
                            },
                          ),
                        ),
                        Text(
                          "Group Messages",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito-Regular',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.archive_outlined, size: 25.0),
                            onPressed: () {
                              Get.to(ChatArchive());
                              print('Archived');
                            },
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
