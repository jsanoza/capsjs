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
  // TextEditingController _contactRegTextController;
  TextEditingController _badgeRegTextController;
  TextEditingController _newemailTextController;

  RoundedLoadingButtonController _btnController;
  RoundedLoadingButtonController _btnControllerCheck;
  RoundedLoadingButtonController _btnControllerConfirm;
  List<double> limits = [];
  List<String> indexList2 = [];
  List<String> choices = ['Team Leader', 'Spotter', 'Spokesperson', 'Patrolman'];
  List<String> choicesRank = ['PO1', 'PO2', 'PO3', 'SPO1', 'SPO2', 'SPO3', 'SPO4', 'P/LT', 'P/CAPT', 'P/MAJ', 'PLTCOL', 'P/COL', 'PBGEN', 'PDIR', 'PDDG', 'PDGEN'];
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
  String initials3;
  String ifdouble;
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
    _newemailTextController = TextEditingController();
    // _contactRegTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    _btnControllerCheck = RoundedLoadingButtonController();
    _btnControllerConfirm = RoundedLoadingButtonController();
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
    var a = await FirebaseFirestore.instance.collection('users').where("badgeNum", isEqualTo: badge).get();
    if (a.docs.isNotEmpty) {
      // print('Exists');
      return true;
    }
    if (a.docs.isEmpty) {
      // print('nope');
      return false;
    }
  }

  Future getEmail(String email) async {
    var a = await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: email).get();
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
    String last3digits;
    String badgeNum = _badgeRegTextController.text;

    //check this tomorrow i want to show the email while user is still typing
    _emailRegTextController.text = '';

    initials = getInitials(fname);
    initials2 = getInitials(mname);
    last3digits = badgeNum.toString().substring(badgeNum.length - 3);

    setState(() {
      finalEmail = initials.toLowerCase().toString() + initials2.toLowerCase().toString() + lname.toLowerCase().toString() + last3digits.toString() + "@acpsone.com";
      finalfinalEmail = finalEmail.split(" ").join("");

      tryEmail = initials.toLowerCase().toString() + initials2.toLowerCase().toString() + lname.toLowerCase().toString() + last3digits.toString();
      finaltryEmail = tryEmail.split(" ").join("");
      _emailRegTextController.text = finaltryEmail;
      ifdouble = initials.toLowerCase().toString() + initials2.toLowerCase().toString() + lname.toLowerCase().toString();
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
Are you sure you want to create an account for: $comp

With badge number: $bNum?

Please double check the credentials.

Auto-generated email is: $finaltryEmail@acpsone.com
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
      var emailCheck = await getEmail(email + '@acpsone.com');

      if (badgeCheck == true) {
        print("andito");
        _showErrorAlert(
            title: "Registration failed.",
            content: 'There is an existing user associated with this badge number.', //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
      } else {
        if (emailCheck == true) {
          print("andito");
          _showModalSheet();
        } else {
          try {
            var url = 'https://capstonejs.000webhostapp.com/simple.php';
            var data = {
              'emailSignup': finalfinalEmail,
              'name': name,
            };
            var response = await http.post(url, body: data);
            uid = response.body;
            print(response.body);
            if (response.body.length == 28) {
              print('imhere');
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
      }
    } catch (e) {
      _showErrorAlert(
          title: "Registration failed.",
          content: e.printError(), //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
    }
  }

  void _showModalSheet() {
    _btnController.reset();
    FocusScope.of(context).requestFocus(new FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    var letssee = ifdouble + '@acpsone.com';
    bool isDisable = true;
    bool isDisableCheck = false;
    bool isReadOnly = false;
    _newemailTextController.text = '';
    // _btnControllerConfirm.stop();
    // var letssee = '';
    // _vehicleplateTextController.text = '';
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () {
            return null;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Container(
                height: 600,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.only(topRight: new Radius.circular(10.0), topLeft: new Radius.circular(10.0)),
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Registration Failed",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 20),
                                child: Text(
                                  "There is an existing user associated with this \n email address.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 20),
                                child: Text(
                                  "To avoid conflicts, please input a new address:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 20),
                                child: Text(
                                  letssee,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20, left: 40, right: 40, top: 10),
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              controller: _newemailTextController,
                              readOnly: isReadOnly,
                              maxLength: 5,
                              maxLengthEnforced: true,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              ],
                              onChanged: (String value) async {
                                if (value != '') {
                                  setState(() {});
                                  mystate(() {
                                    letssee = '';
                                    letssee = ifdouble + _newemailTextController.text + '@acpsone.com';
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Color(0xff085078),
                                    icon: Icon(Icons.contact_mail),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Input numbers',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 10),
                                child: Text(
                                  'Minimum length of 3 digit numbers.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 10),
                                child: Text(
                                  'Maximum length of 5 digit numbers.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, right: 0, left: 5, bottom: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RoundedLoadingButton(
                                      width: 100,
                                      color: Color(0xff1D976C),
                                      child: Text('Check', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                      controller: _btnControllerCheck,
                                      onPressed: isDisableCheck
                                          ? null
                                          : () async {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                                              print("hindi");
                                              var emailCheck = await getEmail(letssee);
                                              if (emailCheck == true) {
                                                _showErrorAlert(
                                                    title: "Registration failed.",
                                                    content: 'There is an existing user associated with this email address.', //show error firebase
                                                    onPressed: _changeBlackVisible,
                                                    context: context);
                                                mystate(() {
                                                  _btnControllerCheck.reset();
                                                });
                                              } else {
                                                mystate(() {
                                                  letssee = ifdouble + _newemailTextController.text + '@acpsone.com' + '  is good to go!';
                                                  isReadOnly = true;
                                                  isDisable = false;
                                                  isDisableCheck = true;
                                                  _btnControllerCheck.reset();
                                                  setState(() {
                                                    _emailRegTextController.text = ifdouble + _newemailTextController.text;
                                                    finalfinalEmail = ifdouble + _newemailTextController.text + '@acpsone.com';
                                                  });
                                                });
                                              }
                                            },
                                    ),
                                    RoundedLoadingButton(
                                      color: Color(0xff085078),
                                      width: 100,
                                      child: Text('Confirm', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                      controller: _btnControllerConfirm,
                                      onPressed: isDisable
                                          ? null
                                          : () async {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                                              print("hindi");
                                              Get.back();
                                              setState(() {
                                                _emailRegTextController.text = ifdouble + _newemailTextController.text;
                                                finalfinalEmail = ifdouble + _newemailTextController.text + '@acpsone.com';
                                                showAlertDialog(context);
                                              });
                                            },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future saveToData() async {
    String fname = _fnameRegTextController.text;
    String mname = _mnameRegTextController.text;
    String lname = _lnameRegTextController.text;
    // String contact = _contactRegTextController.text;
    String badgeNum = _badgeRegTextController.text;
    var collectionid2 = uuid.v1();
    User user = auth.currentUser;
    // var currentUser = user.uid;
    var usercheck;
    fullName = fname + ' ' + lname;
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
      String picUrl = 'https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg';
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
        'contact': '(0000) 000-0000',
        'datecreated': finalCreate,
        'createdby': usercheck,
        'picUrl': picUrl,
        "isphoneverified": false
      }).then((value) {
        FirebaseFirestore.instance.collection("userlevel").doc(uid.toString()).set({
          'fullName': fullName,
          'email': finalfinalEmail,
          'level': 'user',
          'badgeNum': badgeNum,
          'createdby': 'toadd',
          'datecreated': finalCreate,
          "isphoneverified": false,
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
            'editcreate_collectionid': uid.toString(),
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
          // _contactRegTextController.clear();
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 10),
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    TextField(
                      // enabled: false,
                      readOnly: true,
                      controller: _emailRegTextController,
                      maxLength: 32,
                      onChanged: (String value) async {},
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          suffixText: new TextSpan(text: '@acpsone.com  ').text,
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Color(0xff085078),
                            icon: Icon(Icons.mail_outline_sharp),
                            iconSize: 20.0,
                            onPressed: () {},
                          ),
                          contentPadding: EdgeInsets.only(left: 25.0),
                          // hintText: 'Email',
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
                      onChanged: (String value) async {
                        if (value != '') {
                          inputEmail();
                        }
                      },
                      controller: _fnameRegTextController,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Color(0xff085078),
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
                      onChanged: (String value) async {
                        if (value != '') {
                          inputEmail();
                        }
                      },
                      controller: _mnameRegTextController,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Color(0xff085078),
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
                      onChanged: (String value) async {
                        inputEmail();
                      },
                      maxLength: 50,
                      controller: _lnameRegTextController,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Color(0xff085078),
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
                      onChanged: (String value) async {
                        inputEmail();
                      },
                      maxLength: 10,
                      decoration: InputDecoration(
                          counterText: '',
                          isDense: true,
                          prefixIcon: IconButton(
                            color: Color(0xff085078),
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
                        child: Icon(Icons.how_to_reg, size: 20, color: Color(0xff085078)),
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
                        child: Icon(Icons.military_tech, size: 20, color: Color(0xff085078)),
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
            // Padding(
            //   padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 12),
            //   child: Container(
            //     width: 480,
            //     child: Column(
            //       children: [
            //         TextField(
            //           keyboardType: TextInputType.number,
            //           maxLength: 11,
            //           controller: _contactRegTextController,
            //           decoration: InputDecoration(
            //               counterText: '',
            //               isDense: true,
            //               prefixIcon: IconButton(
            //                 color: Colors.green,
            //                 icon: Icon(Icons.contact_page),
            //                 iconSize: 20.0,
            //                 onPressed: () {},
            //               ),
            //               contentPadding: EdgeInsets.only(left: 25.0),
            //               hintText: 'Contact Number',
            //               border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, right: 0, left: 0, bottom: 10),
              child: Container(
                // height: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoundedLoadingButton(
                          color: Color(0xff085078),
                          child: Text('Register', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                          controller: _btnController,
                          onPressed: () {
                            // _showModalSheet();
                            if (_emailRegTextController.text.isEmpty || _fnameRegTextController.text.isEmpty || _badgeRegTextController.text.isEmpty || dropdownValue == null || newValue == null || _lnameRegTextController.text.isEmpty || _mnameRegTextController.text.isEmpty) {
                              print(dropdownValue);
                              print(newValue);
                              _btnController.reset();
                              FocusScope.of(context).requestFocus(new FocusNode());
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                              _showErrorAlert(
                                  title: "Registration failed.",
                                  content: 'All fields required!', //show error firebase
                                  onPressed: _changeBlackVisible,
                                  context: context);
                            } else if (newValue == 'Team Leader' && dropdownValue == 'PO1' ||
                                newValue == 'Team Leader' && dropdownValue == 'PO2' ||
                                newValue == 'Team Leader' && dropdownValue == 'PO3' ||
                                newValue == 'Team Leader' && dropdownValue == 'SPO1' ||
                                newValue == 'Team Leader' && dropdownValue == 'SPO2' ||
                                newValue == 'Team Leader' && dropdownValue == 'SPO3' ||
                                newValue == 'Team Leader' && dropdownValue == 'SPO4') {
                              print('the chosen rank is not allowed to be a team leader');
                              _showErrorAlert(
                                  title: "Registration failed.",
                                  content: 'The chosen rank is not allowed to be a team leader', //show error firebase
                                  onPressed: _changeBlackVisible,
                                  context: context);
                              _btnController.reset();
                              FocusScope.of(context).requestFocus(new FocusNode());
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            } else {
                              showAlertDialog(context);
                              _btnController.reset();
                              FocusScope.of(context).requestFocus(new FocusNode());
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            }
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
          height: 450,
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
                        // title:
                        // Allows the user to reveal the app bar if they begin scrolling back
                        // up the list of items.

                        brightness: Brightness.light,
                        backgroundColor: Color(0xff085078),
                        floating: true,
                        pinned: true,
                        snap: true,
                        shadowColor: Colors.blueAccent,
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
                              'https://media.istockphoto.com/photos/emergency-warning-red-and-blue-roof-mounted-police-led-blinker-light-picture-id1146976107?k=6&m=1146976107&s=612x612&w=0&h=4OL7YImgt5sNGLeL6BN1jW4rhHzMwwIcjEGxqluvgPw=',
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
                                new Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30, bottom: 40),
                                      child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.circular(10.0),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                          ),
                                          child: _buildMain()),
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
                                        // MyButton(text: "Reset Users Password", iconData: Icons.replay, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 3),
                                        MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 5),
                                        MyButton(text: "Manage Users", iconData: Icons.settings_applications, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
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
                                            color: Color(0xff085078),
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
