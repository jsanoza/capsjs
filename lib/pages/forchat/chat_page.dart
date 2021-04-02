import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'chat_screen.dart';

class ChatPage extends StatefulWidget {
  final String groupname, collectionid;

  const ChatPage({Key key, this.groupname, this.collectionid}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isResize = false;
  double height = 100;
  String uid;
  var usercheck;
  var userrank;
  var ppurl;
  String infotitle = '';
  List<String> memberspic = [];
  List<String> membersname = [];
  List<String> members = [];
  List<String> pointlist = [];
  String email2;
  static var _listViewScrollController = new ScrollController();
  // String heightOpen;
  // TextAlignVertical heightOpen = TextAlignVertical.top;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool sentByMe = false;
  TextEditingController messageEditingController = new TextEditingController();

  getShop2() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection('chat_schedule').doc(widget.collectionid).collection('messages').orderBy('time').snapshots();
    return qn;
  }

  @override
  void initState() {
    _listViewScrollController = ScrollController();
    User user = auth.currentUser;
    uid = user.uid;
    getMembers();
    getLoggedinCred();
    isResize = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  getLoggedinCred() async {
    QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: uid).get();
    username.docs.forEach((document) {
      userrank = document.data()['rank'];
      usercheck = document.data()['fullName'];
      ppurl = document.data()['picUrl'];
    });
  }

  getMembers() async {
    QuerySnapshot username = await FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: widget.collectionid).get();
    username.docs.forEach((document) async {
      pointlist = new List.from(document.data()['memberuid']);
    });
  }

  getMembersInfo() async {
    for (var i = 0; i < pointlist.length; i++) {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: pointlist[i].toString()).get();
      username.docs.forEach((document) {
        // print(document.data());
        // members.add(document.data()['memberuid'].toString());
        memberspic.add(document.data()['picUrl'].toString());
        membersname.add(document.data()['rank'].toString() + ' ' + document.data()['fullName'].toString());
        // memberspic = new List.from(document.data()['picUrl']);
        // membersname = new List.from(document.data()['rank'] + ' ' + document.data()['fullName'].toString());
      });
    }
    setState(() {
      infotitle = 'Members: ' + membersname.length.toString();
    });
    showAlertDialog(context);
  }

  void _scrollToBottom() {
    if (_listViewScrollController.hasClients) {
      setState(() {
        _listViewScrollController.animateTo(_listViewScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
      });
    } else {
      Timer(Duration(milliseconds: 300), () => _scrollToBottom());
    }
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        memberspic = [];
        membersname = [];
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(infotitle),
      content: Container(
        height: 300,
        width: Get.width,
        child: ListView.builder(
            itemCount: membersname.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                // alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0, left: 0.0, right: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(memberspic[index]),
                            ),
                          ),
                          title: Text(membersname[index]),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Theme.of(context).accentColor),
          onPressed: () {
            Get.offAll(ChatScreen(
              wherefrom: 'page',
            ));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () async {
              getMembersInfo();

              print(members.toString());
            },
          )
        ],
        backgroundColor: Colors.white,
        title: AutoSizeText(
          widget.groupname,
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito-Regular',
          ),
          maxLines: 1,
          maxFontSize: 22,
          minFontSize: 20,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        elevation: 5.0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: isResize ? const EdgeInsets.only(bottom: 158) : const EdgeInsets.only(bottom: 58),
                child: StreamBuilder(
                  stream: getShop2(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            controller: _listViewScrollController,
                            itemBuilder: (context, index) {
                              DateTime myDateTime = snapshot.data.docs[index]["timestamp"].toDate();
                              String formattedTime1 = DateFormat.jm().format(myDateTime);
                              if (uid == snapshot.data.docs[index]["senderuid"].toString()) {
                                print(snapshot.data.docs[index]["senderuid"].toString());
                                sentByMe = true;
                              } else {
                                sentByMe = false;
                              }

                              return sentByMe
                                  ? Container(
                                      padding: EdgeInsets.only(top: 4, bottom: 4, right: 24),
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 30),
                                                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(15), bottomLeft: Radius.circular(8)),
                                                    color: Colors.blueAccent,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(snapshot.data.docs[index]["message"], textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3.0, left: 50),
                                            child: Row(
                                              children: [
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                Spacer(
                                                  flex: 2,
                                                ),
                                                Text('Me @ ' + formattedTime1, textAlign: TextAlign.start, style: TextStyle(fontSize: 12.0, color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 24),
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 3.0, left: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                Text(snapshot.data.docs[index]["sender"], textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white)),
                                                Spacer(
                                                  flex: 3,
                                                ),
                                                Spacer(
                                                  flex: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0.0, right: 8),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(snapshot.data.docs[index]["picUrl"]),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 30),
                                                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                                                    color: Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(snapshot.data.docs[index]["message"], textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.black)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3.0, right: 50),
                                            child: Row(
                                              children: [
                                                Spacer(
                                                  flex: 1,
                                                ),
                                                Spacer(
                                                  flex: 2,
                                                ),
                                                Text(formattedTime1, textAlign: TextAlign.start, style: TextStyle(fontSize: 12.0, color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            })
                        : Container();
                  },
                ),
              ),
              // Container(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: new Radius.circular(10.0), topRight: new Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  height: isResize ? 150 : 50,
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.bottomLeft,
                        margin: new EdgeInsets.symmetric(horizontal: 0.0),
                        child: new IconButton(
                            icon: new Icon(
                              Icons.photo_camera,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () async {}),
                      ),
                      Expanded(
                        child: Container(
                          child: Focus(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              controller: messageEditingController,
                              onChanged: (String val) {
                                setState(() {
                                  isResize = true;
                                  height = 150;
                                  _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent);
                                });
                              },
                              maxLines: 100000,
                              minLines: 1,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: "Send a message ...",
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none),
                            ),
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent);
                                height = 150;
                                isResize = true;
                              });
                              if (!hasFocus) {
                                setState(() {
                                  height = 50;
                                  isResize = false;
                                });
                              } else if (hasFocus) {
                                setState(() {
                                  _scrollToBottom();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // _sendMessage();
                          String fullRanknName = userrank.toString() + ' ' + usercheck.toString();
                          if (messageEditingController.text.isNotEmpty) {
                            FirebaseFirestore.instance.collection("chat_schedule").doc(widget.collectionid.toString()).collection('messages').doc().set({
                              'message': messageEditingController.text,
                              'senderuid': uid,
                              'time': DateTime.now().millisecondsSinceEpoch,
                              'timestamp': Timestamp.now(),
                              'sender': fullRanknName,
                              'picUrl': ppurl,
                            }).then((value) {
                              FirebaseFirestore.instance.collection("chat_schedule").doc(widget.collectionid.toString()).update({
                                'recentmessage': messageEditingController.text,
                                'recentmessagesender': fullRanknName,
                                'recentmessagetime': Timestamp.now(),
                              });
                            });
                          }
                          _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent);
                          setState(() {
                            messageEditingController.text = '';
                            _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent);
                            Timer(Duration(seconds: 1), () => _listViewScrollController.jumpTo(_listViewScrollController.position.maxScrollExtent));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, right: 8),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Icon(
                              Icons.send,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
