import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../loginsignup.dart';

class UpgradeUserLevel extends StatefulWidget {
  @override
  _UpgradeUserLevelState createState() => _UpgradeUserLevelState();
}

class _UpgradeUserLevelState extends State<UpgradeUserLevel> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();

  RoundedLoadingButtonController _btnController;
  List<double> limits = [];
  List<String> indexList2 = [];
  String dropdownValue;
  String searchString;
  String oldPost;
  String uid;
  bool isMenuOpen = false;
  bool isShown = false;
  bool _blackVisible = false;
  List<String> choices = ['admin', 'user'];
  String newValue;
  String collectionid;
  String name;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid();
  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    _btnController = RoundedLoadingButtonController();
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  Future getBadge(String badge) async {
    var a = await FirebaseFirestore.instance.collection('userlevel').where("fullName", isEqualTo: badge).get();
    if (a.docs.isNotEmpty) {
      // print('Exists');
      var hello = a.docs[0];
      var data = hello.data()['level'];
      // collectionid = hello.data()['collectionId'];
      name = hello.data()['fullName'];
      // print(collectionid);
      return data;
    }
    if (a.docs.isEmpty) {
      // print('nope');
      return false;
    }
  }

  Future check(fullName) async {
    var outputFormat2x = DateFormat('MM-dd-yyyy hh:mm a');
    var finalCreatex = outputFormat2x.format(DateTime.now());
    // List<String> toadd = ["toadd at $finalCreatex"];

    try {
      // var badgeCheck = await getBadge(fullName);
      // print(badgeCheck);
      var collectionid2 = uuid.v1();
      User user = auth.currentUser;
      var currentUser = user.uid;
      var usercheck;
      var collectionidchange;
      var activity = 'Edited User Level of: $name';

      var badgeCheck = await getBadge(fullName);
      print(badgeCheck);
      print(newValue);
      print(fullName);

      if (badgeCheck == newValue) {
        print('same');
        _showErrorAlert(
            title: "UPDATING FAILED",
            content: 'Cannot update to the same level', //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
        _btnController.reset();
        //show error alert here
      } else {
        //get logged in user
        QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
        username.docs.forEach((document) {
          usercheck = document.data()['fullName'];
        });
        //get the chosen user uid
        QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: fullName).get();
        usernamex.docs.forEach((document) {
          collectionidchange = document.data()['collectionId'];
        });

        print(usercheck);
        print(collectionidchange);
        FirebaseFirestore.instance.collection("userlevel").doc(collectionidchange).update({
          "level": newValue,
          // "timepostedit": finalCreatex,
        }).then((value) {
          FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
            // 'collectionid2': collectionid2,
            'userid': user.uid,
            'userfullname': usercheck,
            'this_collectionid': collectionid2,
            'activity': activity,
            'editcreate_datetime': Timestamp.now(),
            'editcreate_collectionid': collectionidchange,
          });
        }).then((value) {
          _showSuccessAlert(
              title: "Congrats!",
              content: "Successfully Updated!", //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          Timer(Duration(seconds: 2), () {
            setState(() {
              Get.snackbar(
                "Success!",
                "Successfully Updated!",
                duration: Duration(seconds: 3),
              );
              _btnController.reset();
            });
          });
        });
      }
    } catch (e) {
      _showErrorAlert(
          title: "UPDATING FAILED",
          content: e.printError(), //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        _btnController.reset();
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // sendReqChange();
        check(dropdownValue);
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        '''
Confirm updating level of: 
$dropdownValue
to:
$newValue 
''',
        maxLines: 20,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      actions: [
        cancelButton,
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

  void _changeBlackVisible() {
    _blackVisible = !_blackVisible;
  }

  void _showSuccessAlert({String title, String content, VoidCallback onPressed, BuildContext context}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog1(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed, BuildContext context}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 25;
    double contLimit = position.dy + renderBox.size.height - 25;
    double step = (contLimit - start) / 6;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 15 : 12;
    return size;
  }

  _buildMain2() {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 10),
                  child: Text(
                    "Edit User Level",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Nunito-Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, left: 20),
                          child: Text(
                            "Select a user:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      width: 340,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('userlevel').orderBy('level').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('');
                            } else if (snapshot.connectionState == ConnectionState.done) {
                              return Text('');
                            } else {
                              if (snapshot.data == null) {
                                return Text('');
                              } else {
                                return new Container(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
                                      child: Stack(children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2))),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5.0, top: 5),
                                                child: Icon(Icons.how_to_reg, size: 20, color: Color(0xff085078)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.0),
                                                border: Border.all(color: Color(0xff085078), style: BorderStyle.solid, width: 0.80),
                                              ),
                                              height: 50,
                                              width: 340,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 40.0),
                                                child: DropdownButton<String>(
                                                  underline: SizedBox(),
                                                  items: snapshot.data.docs.map((DocumentSnapshot document) {
                                                    return new DropdownMenuItem<String>(
                                                      value: document["fullName"].toString(),
                                                      child: Text(document["fullName"].toString() + " - " + document["level"].toString()),
                                                    );
                                                  }).toList(),
                                                  hint: new Text("Name"),
                                                  isExpanded: true,
                                                  value: dropdownValue,
                                                  onChanged: (String newValuex) {
                                                    dropdownValue = newValuex;
                                                    setState(() {
                                                      FocusScope.of(context).requestFocus(new FocusNode());
                                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ));
                              }
                            }
                          }),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, left: 20),
                          child: Text(
                            "Update level to:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
                      child: Stack(children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2))),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, top: 5),
                                child: Icon(Icons.how_to_reg, size: 20, color: Color(0xff085078)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Color(0xff085078), style: BorderStyle.solid, width: 0.80),
                          ),
                          height: 50,
                          width: 340,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              items: choices.map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              hint: new Text("Level"),
                              isExpanded: true,
                              value: newValue,
                              onChanged: (String newValuex) {
                                newValue = newValuex;
                                setState(() {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                });
                              },
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 0, left: 0, bottom: 0),
                      child: Container(
                        child: Column(
                          children: [
                            RoundedLoadingButton(
                              color: Color(0xff085078),
                              child: Text('Update', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                              controller: _btnController,
                              onPressed: () {
                                setState(() {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  showAlertDialog(context);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  signOut() {
    User user = auth.currentUser;
    var collectionid2 = uuid.v1();

    FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
      'lastactivity_datetime': Timestamp.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
        'userid': user.uid,
        'activity': 'Logged out session.',
        'editcreate_datetime': Timestamp.now(),
      });
    }).then((value) {
      auth.signOut();
      Get.offAll(LogSign());
    });
  }

  @override
  Widget build(BuildContext context) {
    double sidebarSize = Get.width * 0.60;
    double menuContainerHeight = Get.height / 2;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(children: <Widget>[
        Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(bottomRight: new Radius.circular(30.0), bottomLeft: new Radius.circular(0.0)),
            gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isMenuOpen = false;
            });
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            // ignore: missing_return
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: Container(
              height: Get.height,
              decoration: BoxDecoration(),
              child: Stack(
                children: <Widget>[
                  CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Color(0xff085078),
                        floating: true,
                        pinned: true,
                        snap: true,
                        shadowColor: Color(0xff085078),
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "User Level",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: AvatarGlow(
                                      startDelay: Duration(milliseconds: 0),
                                      glowColor: Colors.red,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 0),
                                      child: IconButton(
                                        iconSize: 25.0,
                                        icon: Icon(Icons.menu),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            isMenuOpen = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            background: Image.network(
                              'https://ak.picdn.net/shutterstock/videos/4296944/thumb/1.jpg',
                              fit: BoxFit.cover,
                            )),
                        expandedHeight: 200,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int pdIndex) {
                            return SingleChildScrollView(
                              child: Column(children: [
                                Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30, bottom: 80),
                                      child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.circular(10.0),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                          ),
                                          child: _buildMain2()),
                                    ),
                                  ],
                                )
                                //... The children inside the column of ListView.builder
                              ]),
                            );
                          },
                          // Builds 1000 ListTiles
                          childCount: 1,
                        ),
                      )
                    ],
                  ),

                  //here starts of the animation and navigation bar
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1500),
                    //gawing + 1 if gusto mo may nakalitaw
                    //pero much better looking if + 0
                    left: isMenuOpen ? 0 : -sidebarSize + 0,
                    top: 0,
                    curve: Curves.elasticOut,
                    child: SizedBox(
                      width: sidebarSize,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          if (details.localPosition.dx <= sidebarSize) {
                            setState(() {
                              _offset = details.localPosition;
                            });
                          }

                          if (details.localPosition.dx > sidebarSize - 20 && details.delta.distanceSquared > 2) {
                            setState(() {
                              isMenuOpen = true;
                            });
                          }
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _offset = Offset(0, 0);
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            CustomPaint(
                              size: Size(sidebarSize, Get.height),
                              painter: DrawerPainter(offset: _offset),
                            ),
                            Container(
                              height: Get.height,
                              width: sidebarSize,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: Get.height * 0.30,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 120,
                                            width: 120,
                                            // padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(UserLog.ppUrl),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 28.0),
                                            child: Text(
                                              UserLog.rank + '. ' + UserLog.fullName.toUpperCase(),
                                              style: TextStyle(color: Colors.black45),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  Container(
                                    key: globalKey,
                                    width: double.infinity,
                                    height: menuContainerHeight,
                                    child: Column(
                                      children: <Widget>[
                                        MyButton(text: "Schedule Details", iconData: Icons.person, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 0),
                                        MyButton(text: "Add Schedule", iconData: Icons.payment, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 1),
                                        // MyButton(text: "Register New User", iconData: Icons.notifications, textSize: getSize(2), height: (menuContainerHeight) / 6, selectedIndex: 2),
                                        // MyButton(text: "Reset User Password", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 3),
                                        MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 5),
                                        MyButton(text: "Manage Users", iconData: Icons.settings_applications, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                        // MyButton(
                                        //     text: "Fourth",
                                        //     iconData: Icons.settings,
                                        //     textSize: getSize(4),
                                        //     height: (menuContainerHeight) / 5,
                                        //     selectedIndex: 4),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Logout Confirmation"),
                                                content: const Text("Are you sure you want to log out?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () => {
                                                            signOut(),
                                                          },
                                                      child: const Text("Yes")),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Color(0xff085078),
                                            size: 25.0,
                                          ),
                                          Text(
                                            '  Logout',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Nunito-Bold'),
                                          ),
                                        ],
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
