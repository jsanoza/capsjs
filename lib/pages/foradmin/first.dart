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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../loginsignup.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  TextEditingController _emailRegTextController;
  TextEditingController _lnameRegTextController;
  TextEditingController _fnameRegTextController;
  TextEditingController _mnameRegTextController;
  TextEditingController _posRegTextController;
  TextEditingController _rankRegTextController;
  TextEditingController _contactRegTextController;
  TextEditingController _badgeRegTextController;
  RoundedLoadingButtonController _btnController;
  List<double> limits = [];
  List<String> indexList2 = [];
  List<String> choices = ['Team Leader', 'Spotter', 'Spokesperson', 'Patrolman'];
  List<String> choicesRank = [
    'Patrolman / Patrolwoman (Pat.) / Police Officer I (PO1)',
    'Police Corporal (PCpl.) / Police Officer II (PO2)',
    'Police Staff Sergeant (PSSgt.) / Police Officer III (PO3)',
    'Police Master Sergeant (PMSgt.) / 	Senior Police Officer I (SPO1)',
    'Police Senior Master Sergeant (PSMS) / Senior Police Officer II (SPO2)',
    'Police Chief Master Sergeant (PCMS) / Senior Police Officer III (SPO3)',
    'Police Executive Master Sergeant (PEMS) / Senior Police Officer IV (SPO4)',
    'Police Lieutenant (P/LT) / Police Inspector (PINSP)',
    'Police Captain (P/CAPT) / 	Police Senior Inspector (PS/INSP)',
    'Police Major (P/MAJ) / Police Chief Inspector (PC/INSP)',
    'Police Lieutenant Colonel (PLTCOL) / Police Superintendent (PSUPT)',
    'Police Colonel (P/COL) / Police Senior Superintendent (PS/SUPT',
    'Police Brigadier General (PBGEN) /	Police Chief Superintendent (PC/SUPT)',
    'Police Major General (PMGEN) / 	Police Director (PDIR)',
    'Police Lieutenant General (PLTGEN) / Police Deputy Director General (PDDG)',
    'Police General (P/GEN) / Police Director General (PDGEN)'
  ];
  String dropdownValue;
  String newValue;
  String searchString;
  String uid;
  bool isMenuOpen = false;
  bool isShown = false;
  String finalEmail;
  String finalfinalEmail;
  String tryEmail;
  String finaltryEmail;
  String fullName;
  String initials;
  String initials2;
  var uuid = Uuid();

  bool _blackVisible = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    _emailRegTextController = TextEditingController();
    _fnameRegTextController = TextEditingController();
    _lnameRegTextController = TextEditingController();
    _mnameRegTextController = TextEditingController();
    _badgeRegTextController = TextEditingController();
    _posRegTextController = TextEditingController();
    _rankRegTextController = TextEditingController();
    _contactRegTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    isShown = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  getInitials(String word) {
    List<String> names = word.split(" ");
    String initials = "";
    int numWords = 0;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  void _changeBlackVisible() {
    _blackVisible = !_blackVisible;
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
//this module will check if existing user
  // Future getDoc(String b) async {
  //   var a = await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: b).get();
  //   if (a.docs.isNotEmpty) {
  //     print('Exists');
  //     return a;
  //   }
  //   if (a.docs.isEmpty) {
  //     print('Not exists');
  //     return null;
  //   }
  // }

  Future getBadge(String badge) async {
    var a = await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: badge).get();
    if (a.docs.isNotEmpty) {
      // print('Exists');
      return true;
    }
    if (a.docs.isEmpty) {
      // print('nope');
      return false;
    }
  }

  // sendData2() async {
  //   String fname = _fnameRegTextController.text;
  //   String a = getInitials(fname);
  //   print(a.toLowerCase());
  //   var hello = getDoc("jeremiah@gg.com");
  //   print(hello);
  //   // final snapShot = FirebaseFirestore.instance.collection('users').snapshots();
  //   String getIsNewUSer = "othercampuses@qq.com";
  // }

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

  inputEmail() async {
    String fname = _fnameRegTextController.text;
    String mname = _mnameRegTextController.text;
    String lname = _lnameRegTextController.text;
    initials = getInitials(fname);
    initials2 = getInitials(mname);
    String badgeNum = _badgeRegTextController.text;
    String last3digits = badgeNum.toString().substring(badgeNum.length - 3);
    //check this tomorrow i want to show the email while user is still typing

    setState(() {
      finalEmail = initials.toLowerCase().toString() + initials2.toLowerCase().toString() + lname.toLowerCase().toString() + last3digits.toString() + "@acpstwo.com";
      finalfinalEmail = finalEmail.split(" ").join("");
      tryEmail = initials.toLowerCase().toString() + initials2.toLowerCase().toString() + lname.toLowerCase().toString() + last3digits.toString();
      finaltryEmail = tryEmail.split(" ").join("");
      fullName = fname.toString() + " " + lname.toString();
      _emailRegTextController.text = finaltryEmail;
      print(finalfinalEmail.toString());
    });
  }

  showAlertDialog(BuildContext context) {
    String bNum = _badgeRegTextController.text;
    String fname = _fnameRegTextController.text;
    String lname = _lnameRegTextController.text;
    String comp = fname.toString() + " " + lname.toString();
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
        sendData();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        '''
Are you sure to create an account for: $comp

With badge number: $bNum?

Please double check the credentials.

Auto-generated email is: $finaltryEmail@acpstwo.com
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

//add the email automatically after typing
  Future sendData() async {
    User user = auth.currentUser;
    String email = _emailRegTextController.text;
    String fname = _fnameRegTextController.text;
    String mname = _mnameRegTextController.text;
    String lname = _lnameRegTextController.text;
    String badgeNum = _badgeRegTextController.text;
    String name = fname.toString() + " " + lname.toString();

    try {
      var badgeCheck = await getBadge(badgeNum);
      print(badgeCheck);

      if (badgeCheck == true) {
        print("andito");
      } else {
        print("wala");
        try {
          var url = 'http://capstonejs.000webhostapp.com/simple.php';
          var data = {
            'emailSignup': finalfinalEmail,
            'name': name,
          };
          var response = await http.post(url, body: jsonEncode(data));
          uid = response.body;
          print(response.body);
          if (response.body.length == 28) {
            saveToData();
          } else {
            _showErrorAlert(
                title: "Registration failed.",
                content: "Check your credentials", //show error firebase
                onPressed: _changeBlackVisible,
                context: context);
          }
        } catch (e) {
          _showErrorAlert(
              title: "Registration failed.",
              content: e.printError(), //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
        }
      }
    } catch (e) {
      _showErrorAlert(
          title: "Registration failed.",
          content: e.printError(), //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
    }
  }

  Future saveToData() async {
    String fname = _fnameRegTextController.text;
    String mname = _mnameRegTextController.text;
    String lname = _lnameRegTextController.text;
    String contact = _contactRegTextController.text;
    String badgeNum = _badgeRegTextController.text;
    var collectionid2 = uuid.v1();
    User user = auth.currentUser;
    var currentUser = user.uid;
    var usercheck;
    var activity = 'Created a new user with the name: $fullName';

    var outputFormat2 = DateFormat('dd-MM-yyyy');
    var finalCreate = outputFormat2.format(DateTime.now());
    List<String> splitList = finalEmail.split(' ');

    // List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length + i; j++) {
        // indexList.add(splitList[i].substring(0, j).toUpperCase());
        indexList2.add(splitList[i].substring(0, j).toUpperCase());
      }
    }
    if (newValue == "Team Leader") {
      newValue = "Leader";
    } else {
      newValue = newValue;
    }
    QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    username.docs.forEach((document) {
      usercheck = document.data()['fullName'];
    });

    try {
      String picUrl = 'https://firebasestorage.googleapis.com/v0/b/capstonejs-cc692.appspot.com/o/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg?alt=media&token=6115e19e-e612-4e18-b730-9b32c9ee3f25';
      FirebaseFirestore.instance.collection("users").doc(uid.toString()).set({
        'searchKey': indexList2,
        'collectionId': uid.toString(),
        'email': finalfinalEmail,
        'fullName': fullName,
        'fname': fname,
        'lname': lname,
        'mname': mname,
        'badgeNum': badgeNum,
        'position': newValue,
        'rank': dropdownValue,
        'contact': contact,
        'datecreated': finalCreate,
        'createdby': 'toadd',
        'picUrl': picUrl
      }).then((value) {
        FirebaseFirestore.instance.collection("userlevel").doc(uid.toString()).set({
          'fullName': fullName,
          'email': finalfinalEmail,
          'level': 'user',
          'badgeNum': badgeNum,
          'createdby': 'toadd',
          'datecreated': finalCreate,
        });

        FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
          // 'collectionid2': collectionid2,
          'lastactivity.datetime': Timestamp.now(),
        }).then((value) {
          FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
            // 'collectionid2': collectionid2,
            'userid': user.uid,
            'userfullname': usercheck,
            'this.collectionid': collectionid2,
            'activity': activity,
            'editcreate.datetime': Timestamp.now(),
            'editcreate.collectionid': uid.toString(),
          });
        });

        print("done");
        indexList2.clear();
        setState(() {
          dropdownValue = null;
          newValue = null;
          _emailRegTextController.clear();
          _fnameRegTextController.clear();
          _badgeRegTextController.clear();
          _posRegTextController.clear();
          _rankRegTextController.clear();
          _contactRegTextController.clear();
          _lnameRegTextController.clear();
          _mnameRegTextController.clear();
          FocusScope.of(context).requestFocus(new FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          _showSuccessAlert(
              title: "Congrats!",
              content: "Successfully Created!", //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          _btnController.success();
          Timer(Duration(seconds: 3), () {
            setState(() {
              _btnController.reset();
              Get.snackbar(
                "Success!",
                "New Credentials Added.",
                duration: Duration(seconds: 3),
              );
            });
          });
        });
      });
    } catch (e) {
      _showErrorAlert(
          title: "Registration failed.",
          content: e.printError(), //show error firebase
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

  _buildMain() {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 80, bottom: 10),
              child: Text(
                "Register New Credentials",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 12, right: 0),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 230,
                          child: TextField(
                            enabled: false,
                            controller: _emailRegTextController,
                            maxLength: 32,
                            inputFormatters: [
                              new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                            ],
                            decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                prefixIcon: IconButton(
                                  color: Colors.green,
                                  icon: Icon(Icons.mail_outline_sharp),
                                  iconSize: 20.0,
                                  onPressed: () {},
                                ),
                                contentPadding: EdgeInsets.only(left: 25.0),
                                hintText: 'Email',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("@acpstwo.com"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      maxLength: 50,
                      controller: _fnameRegTextController,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.perm_identity),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'First Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      maxLength: 50,
                      controller: _mnameRegTextController,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.perm_identity),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Middle Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (String value) {},
                      maxLength: 50,
                      controller: _lnameRegTextController,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.perm_identity),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Last Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _badgeRegTextController,
                      maxLength: 10,
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.payment),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Badge Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ],
                ),
              ),
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
                        child: Icon(Icons.how_to_reg, size: 20, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 0.80),
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
                      hint: new Text("Position"),
                      isExpanded: true,
                      value: newValue,
                      onChanged: (String newValuex) {
                        // _posRegTextController.text = newValue.toString();
                        newValue = newValuex;
                        setState(() {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          inputEmail();
                          print(newValue.toString());
                        });
                      },
                    ),
                  ),
                ),
              ]),
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
                        child: Icon(Icons.military_tech, size: 20, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 0.80),
                  ),
                  height: 50,
                  width: 340,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      items: choicesRank.map((String val) {
                        return new DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
                      hint: new Text("Rank"),
                      isExpanded: true,
                      value: dropdownValue,
                      onChanged: (String newValuex) {
                        // _posRegTextController.text = newValue.toString();
                        dropdownValue = newValuex;
                        setState(() {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                          inputEmail();
                          print(dropdownValue.toString());
                        });
                      },
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      controller: _contactRegTextController,
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Colors.green,
                            icon: Icon(Icons.contact_page),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          hintText: 'Contact Number',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, right: 0, left: 0, bottom: 10),
              child: Container(
                // height: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // RaisedButton(
                        //   onPressed: () {
                        //     sendData();
                        //     // sendData2();
                        //   },
                        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                        //   padding: const EdgeInsets.all(0.0),
                        //   child: Ink(
                        //     decoration: const BoxDecoration(
                        //       gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                        //       borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        //     ),
                        //     child: Container(
                        //       constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                        //       alignment: Alignment.center,
                        //       child: Icon(Icons.check, size: 20, color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                        RoundedLoadingButton(
                          color: Color(0xff1D976C),
                          child: Text('Register', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
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
      'lastactivity.datetime': Timestamp.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
        'userid': user.uid,
        'activity': 'Logged out session.',
        'editcreate.datetime': Timestamp.now(),
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
          height: 450,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(bottomRight: new Radius.circular(30.0), bottomLeft: new Radius.circular(0.0)),
            gradient: new LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                        // title:
                        // Allows the user to reveal the app bar if they begin scrolling back
                        // up the list of items.
                        brightness: Brightness.light,
                        backgroundColor: Color(0xff1D976C),
                        floating: true,
                        pinned: true,
                        snap: true,
                        shadowColor: Colors.green,
                        // Display a placeholder widget to visualize the shrinking size.
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
                                      "Credentials",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: AvatarGlow(
                                      startDelay: Duration(milliseconds: 0),
                                      glowColor: Colors.lime,
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
                              'https://cloudfront-us-east-1.images.arcpublishing.com/cmg/PZQVBPFW2FXTEMMO2EVXFTEXJA.jpg',
                              fit: BoxFit.cover,
                            )),
                        // Make the initial height of the SliverAppBar larger than normal.
                        expandedHeight: 200,
                      ),
                      SliverList(
                        // Use a delegate to build items as they're scrolled on screen.
                        delegate: SliverChildBuilderDelegate(
                          // The builder function returns a ListTile with a title that
                          // displays the index of the current item.
                          (BuildContext context, int pdIndex) {
                            return SingleChildScrollView(
                              child: Column(children: [
                                Row(
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 25, bottom: 40),
                                              child: Container(
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain()),
                                            ),
                                          ],
                                        ),
                                      ],
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
                    left: isMenuOpen ? 0 : -sidebarSize + 1,
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
                                          Image.asset(
                                            "assets/images/hospital.png",
                                            width: sidebarSize / 2,
                                          ),
                                          Text(
                                            "Big PP",
                                            style: TextStyle(color: Colors.black45),
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
                                        MyButton(text: "Schedule Details", iconData: Icons.text_snippet, textSize: getSize(0), height: (menuContainerHeight) / 6, selectedIndex: 0),
                                        MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 6, selectedIndex: 4),
                                        MyButton(text: "Add Schedule", iconData: Icons.library_add_check, textSize: getSize(2), height: (menuContainerHeight) / 6, selectedIndex: 1),
                                        MyButton(text: "Reset Users Password", iconData: Icons.replay, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 3),
                                        MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(4), height: (menuContainerHeight) / 6, selectedIndex: 5),
                                        // MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
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
                                            color: Colors.lightGreen,
                                            size: 20.0,
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
