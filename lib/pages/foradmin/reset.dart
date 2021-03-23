import 'dart:async';
import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../loginsignup.dart';

class ResetState extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

//TO DO save to DB who ever did the changes
class _ResetState extends State<ResetState> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  TextEditingController _emailTextController;
  RoundedLoadingButtonController _btnController;
  List<double> limits = [];
  List<String> indexList2 = [];
  String dropdownValue;
  String searchString;
  String uid;
  bool isMenuOpen = false;
  bool isShown = false;
  bool _blackVisible = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid();

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];

    _btnController = RoundedLoadingButtonController();
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    _emailTextController = TextEditingController();
    isShown = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  showAlertDialog(BuildContext context) {
    String email = _emailTextController.text;
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        sendReqChange();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        '''
Are you sure you want to reset password of account: $email
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

  Future sendReqChange() async {
    var email = _emailTextController.text;
    User user = auth.currentUser;
    var currentUser = user.uid;
    var collectionid2 = uuid.v1();
    var usercheck;
    var activity = 'Reset password of name: $email';
    try {
      var url = 'https://capstonejs.000webhostapp.com/change.php';
      var data = {
        'emailSignup': email,
      };
      var response = await http.post(url, body: jsonEncode(data));
      uid = response.body;
      print(response.body);
      if (response.body == 'Success') {
        QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
        username.docs.forEach((document) {
          usercheck = document.data()['fullName'];
        });

        FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
          // 'collectionid2': collectionid2,
          'lastactivity_datetime': Timestamp.now(),
        }).then((value) {
          FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
            // 'collectionid2': collectionid2,
            'userid': user.uid,
            'userfullname': usercheck,
            'this_collectionid': collectionid2,
            'activity': activity,
            'editcreate_datetime': Timestamp.now(),
            'editcreate_collectionid': email,
          });
        });

        _showSuccessAlert(
            title: "Congrats!",
            content: "Password Reset Successful!", //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
        FocusScope.of(context).requestFocus(new FocusNode());
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        _btnController.success();
        Timer(Duration(seconds: 3), () {
          setState(() {
            _btnController.reset();
            _emailTextController.clear();
            Get.snackbar(
              "Success!",
              "Password Reset Successful!",
              duration: Duration(seconds: 3),
            );
          });
        });
      } else {
        _showErrorAlert(
            title: "Change Password failed.",
            content: "Reset Password Error!", //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
      }
    } catch (e) {
      print("error!");
      _showErrorAlert(
          title: "Reset Pssword failed.",
          content: "Reset Password Error!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
    }
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
                    "Reset Password",
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
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          isShown = true;
                          searchString = val.toUpperCase();
                        });
                      },
                      controller: _emailTextController,
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                            color: Color(0xff085078),
                            icon: Icon(Icons.mail_outline_sharp),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Search by email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    ),
                    isShown
                        ? Container(
                            height: 100,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('users').where('searchKey', arrayContains: searchString).snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Error2");
                                  }
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff085078)),
                                      ));
                                    case ConnectionState.none:
                                      return Center(
                                          child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff085078)),
                                      ));
                                    case ConnectionState.done:
                                      return Text("done");
                                    default:
                                      return new ListView(
                                          children: snapshot.data.docs.map((DocumentSnapshot document) {
                                        return new ListTile(
                                          title: GestureDetector(
                                            child: Text(document['email']),
                                            onTap: () {
                                              print(document['email']);
                                              setState(() {
                                                _emailTextController.text = document['email'].toString();
                                                isShown = false;
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                              });
                                            },
                                          ),
                                        );
                                      }).toList());
                                  }
                                }),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10.0, right: 0, left: 0, bottom: 0),
                            child: Container(
                              // height: 200,
                              child: Column(
                                children: [
                                  RoundedLoadingButton(
                                    color: Color(0xff085078),
                                    child: Text('Reset', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                    controller: _btnController,
                                    onPressed: () {
                                      //  sendData();
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
                                      "Reset",
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
                              'https://media.socastsrm.com/wordpress/wp-content/blogs.dir/2313/files/2019/06/Police.jpg',
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
                                        MyButton(text: "Schedule Details", iconData: Icons.text_snippet, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 0),
                                        // MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 6, selectedIndex: 4),
                                        MyButton(text: "Add Schedule", iconData: Icons.library_add_check, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 1),
                                        // MyButton(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 2),
                                        MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 5),
                                        MyButton(text: "Manage Users", iconData: Icons.settings_applications, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
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
