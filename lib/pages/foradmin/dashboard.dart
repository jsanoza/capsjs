import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/map.dart';
import 'package:intl/intl.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:osm_nominatim/osm_nominatim.dart';

import '../loginsignup.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  TextEditingController _notesTextController;
  RoundedLoadingButtonController _btnController;
  TextEditingController _missionnameTextController;

  TextEditingController _vehiclekindTextController;
  TextEditingController _vehicleplateTextController;
  TextEditingController _vehiclebrandTextController;
  TextEditingController _vehiclemodelTextController;
  TextEditingController _vehicledescTextController;
  TextEditingController _mapTextConroller;

  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  static int _len = 50;
  List<bool> isChecked = List.generate(_len, (index) => false);
  static int _lenx = 50;
  List<bool> isCheckedArrest = List.generate(_lenx, (index) => false);
  static int _leny = 50;
  List<bool> isCheckedSecurity = List.generate(_leny, (index) => false);
  static int _lenz = 50;
  List<bool> isCheckedBlock = List.generate(_lenz, (index) => false);
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> userSearchItemsx = [];
  List<String> userSearchItemsName = [];
  List<String> userSearchArrestx = [];
  List<String> userSearchArrestName = [];
  List<String> userSearchSecurityx = [];
  List<String> userSearchSecurityName = [];
  List<String> userSearchBlockx = [];
  List<String> userSearchBlockName = [];
  List<String> userFinalItemsArrestForSecurity = [];
  List<String> userFinalItemsArrestSecurityForBlock = [];
  List<String> userLeader = [];
  List<String> _checked = []; //["A", "B"];
  List<String> userAll = [];
  List<String> userAll2 = [];
  List<String> userAll3 = [];
  List<String> userAll4 = [];
  List<String> userCheck = [];
  DateTime finalDatex;
  bool listSelec = false;
  String finalDate;
  String startTime;
  String endTime;
  String docTitle;
  String dropdownValue;
  String dropdownValuex;
  String dropdownValuey;
  bool isMenuOpen = false;
  bool _firstShow = false;
  bool _secondShow = false;
  bool _thirdShow = false;
  bool _fourthShow = false;
  bool _sixthShow = false;
  bool _seventhShow = false;
  bool _eightShow = false;
  bool _blackVisible = false;
  bool _isBut1 = false;
  bool _isBut2 = false;
  bool _isBut3 = false;
  bool _isBut4 = false;
  bool _isBut5 = false;
  bool _isButx1 = false;
  bool _isButx2 = false;
  bool _isButx3 = false;
  bool _isButx4 = false;
  bool _isButx5 = false;
  bool _isButx6 = false;
  bool _isButx7 = false;
  String missionname;
  var uuid = Uuid();

  double lattap = 15.127936526523328;
  double lngtap = 120.60236373735461;
  double lattapnew;
  double lngtapnew;

  List<String> vehiclelist = [];

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);

    _firstShow = false;
    _secondShow = false;
    _thirdShow = false;
    _fourthShow = false;
    _sixthShow = false;
    _notesTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    _missionnameTextController = TextEditingController();

    _vehicledescTextController = TextEditingController();
    _vehiclemodelTextController = TextEditingController();
    _vehiclebrandTextController = TextEditingController();
    _vehicleplateTextController = TextEditingController();
    _vehiclekindTextController = TextEditingController();
    _mapTextConroller = TextEditingController();

    _isBut1 = true;
    _isBut2 = false;
    _isBut3 = false;
    _isBut4 = false;
    _isBut5 = false;
    _isButx1 = true;
    _isButx2 = false;
    _isButx3 = false;
    _isButx4 = false;
    _isButx5 = false;
    _isButx6 = false;
    _isButx7 = false;
    _seventhShow = false;
    _eightShow = false;

    super.initState();
  }

  void _changeBlackVisible() {
    _blackVisible = !_blackVisible;
  }

  showAlertDialog(BuildContext context) {
    String fffDate = finalDate.toString();
    String sssTime = startTime.toString();
    String eeeTime = endTime.toString();
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Get.back();
        _btnController.reset();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        saveToDB();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Schedule"),
      content: Text(
        '''
Are you sure to create a schedule for: 
Starting time: $sssTime
Ends at: $eeeTime

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

  saveToDB() async {
    String notes = _notesTextController.text;
    var collectionid = uuid.v1();
    var collectionid2 = uuid.v1();
    var location = _mapTextConroller.text;
    User user = auth.currentUser;
    var currentUser = user.uid;
    var usercheck;
    var outputFormat2 = DateFormat('MM-dd-yyyy hh:mm a');
    var finalCreate = outputFormat2.format(DateTime.now());
    missionname = _missionnameTextController.text;

    var activity = 'Created a schedule with mission name: $missionname';
    // List<String> activitylist;
    // activitylist.add(activity);

    var b = DateFormat('MM-dd-yyyy HH:mm').parse(startTime.toString());
    Timestamp a = Timestamp.fromDate(b);

    var c = DateFormat('MM-dd-yyyy HH:mm').parse(endTime.toString());
    Timestamp d = Timestamp.fromDate(c);
    QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    username.docs.forEach((document) {
      usercheck = document.data()['fullName'];
    });

    try {
      for (var i = 0; i < vehiclelist.length; i++) {
        QuerySnapshot snap = await FirebaseFirestore.instance.collection('trialvehicles').where("plate", isEqualTo: vehiclelist[i]).get();
        snap.docs.forEach((document) {
          FirebaseFirestore.instance.collection('vehicles').doc(vehiclelist[i]).set({
            'query': document.data()['plate'],
            'vehicle': document.data()['plate'],
            'vehiclebrand': document.data()['brand'],
            'vehicledesc': document.data()['desc'],
            'vehiclekind': document.data()['kind'],
            'vehiclemodel': document.data()['model'],
            'reason': notes,
            'addedby': user.uid,
            'addedtime': Timestamp.now(),
          }).then((value) {
            FirebaseFirestore.instance.collection("trialvehicles").doc(vehiclelist[i]).delete().then((value) {
              print('deleted');
              print(vehiclelist);
            });
          });
        });
      }

      FirebaseFirestore.instance.collection("schedule").doc(collectionid.toString()).set({
        "teamlead": dropdownValue.toString(),
        "spotter": dropdownValuex.toString(),
        "spokesperson": dropdownValuey.toString(),
        // "date": finalDate.toString(),
        "starttime": startTime.toString(),
        "endtime": endTime.toString(),
        "location": location,
        "loclat": lattapnew,
        "loclng": lngtapnew,
        "kind": _checked.toString(),
        "datecreated": Timestamp.now(),
        "createdby": usercheck,
        "status": "toadd",
        "notes": notes,
        "missionname": missionname,
        "collectionid": collectionid,
        "blockteamname": FieldValue.arrayUnion(userSearchBlockx),
        "investteamname": FieldValue.arrayUnion(userSearchItemsx),
        "searchteamname": FieldValue.arrayUnion(userSearchArrestx),
        "secuteamname": FieldValue.arrayUnion(userSearchSecurityx),
        "blockteam": FieldValue.arrayUnion(userSearchBlockName),
        "investteam": FieldValue.arrayUnion(userSearchItemsName),
        "searchteam": FieldValue.arrayUnion(userSearchArrestName),
        "secuteam": FieldValue.arrayUnion(userSearchSecurityName),
        "querystarttime": a,
        "queryendtime": d,
        "vehicle": vehiclelist,
      }).then((value) {
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
            'editcreate.collectionid': collectionid,
          });
        });

        print("done");
        // Navigator.pop(context);
        Get.snackbar(
          "Success!",
          "New Schedule Added.",
          duration: Duration(seconds: 3),
        );
        _showSuccessAlert(
            title: "Congrats!",
            content: "Successfully Created!", //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
        Timer(Duration(seconds: 3), () {
          setState(() {
            _btnController.reset();
            // Get.snackbar(
            //   "Success!",
            //   "New Schedule Added.",
            //   duration: Duration(seconds: 3),
            // );
            Get.offAll(Dashboard());
          });
        });
      });
    } catch (e) {
      _showErrorAlert(
          title: "SCHEDULE FAILED",
          content: e.printError(), //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      //show error ehere
    }
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

  Widget _buildInvestSub() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 43),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  _showModalSheet();
                  // _onTap();
                  // handleSignIn();
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSub() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 8),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  _showModalSheetSearch();
                  // _onTap();
                  // handleSignIn();
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySub() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 85),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  _showModalSecurity();
                  // _onTap();
                  // handleSignIn();
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockSub() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 40),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  _showModalBlock();
                  // _onTap();
                  // handleSignIn();
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getHolder() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("trialvehicles").snapshots();
    return qn;
  }

  getShops() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("users").where("position", isEqualTo: "Patrolman").snapshots();
    return qn;
  }

  getShop2() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("users").snapshots();
    return qn;
  }

  _showBlockList() {
    return Container(
      height: 300,
      width: 480,
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: getShops(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Text('');
          } else {
            if (snapshot.data == null) {
              return Text('');
            } else {
              final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return userSearchBlockName.contains(documentSnapshot['badgeNum']);
              }).toList();
              return Container(
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: Key('item ${userList[index]["badgeNum"]}'),
                      background: Container(
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Remove from the list', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(
                            () {
                              userSearchBlockName.remove(userList[index]["badgeNum"]);
                              userSearchBlockx.remove(userList[index]["fullName"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        } else {
                          setState(
                            () {
                              userSearchBlockName.remove(userList[index]["badgeNum"]);
                              userSearchBlockx.remove(userList[index]["fullName"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        }
                        setState(() {
                          if (userSearchBlockName.isEmpty) {
                            _fourthShow = false;
                          }
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 18.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                    backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                  ),
                                ),
                                title: Text(userList[index]["badgeNum"]),
                                subtitle: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          userList[index]["fullName"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

//done
  _showSecurityList() {
    return Container(
      height: 300,
      width: 480,
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: getShops(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Text('');
          } else {
            if (snapshot.data == null) {
              return Text('');
            } else {
              final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return userSearchSecurityName.contains(documentSnapshot['badgeNum']);
              }).toList();
              return Container(
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: Key('item ${userList[index]["badgeNum"]}'),
                      background: Container(
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Remove from the list', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(
                            () {
                              userSearchSecurityName.remove(userList[index]["badgeNum"]);
                              userSearchSecurityx.remove(userList[index]["fullName"]);
                              // userFinalItemsArrestForSecurity.remove(userList[index]["badgeNum"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        } else {
                          setState(
                            () {
                              userSearchSecurityName.remove(userList[index]["badgeNum"]);
                              userSearchSecurityx.remove(userList[index]["fullName"]);
                              // userFinalItemsArrestForSecurity.remove(userList[index]["badgeNum"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        }
                        setState(() {
                          if (userSearchSecurityName.isEmpty) {
                            _thirdShow = false;
                          }
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 18.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                    backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                  ),
                                  // child: Text("hellox"),
                                ),
                                title: Text(userList[index]["badgeNum"]),
                                subtitle: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          userList[index]["fullName"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

//done
  _showApprovedListx() {
    return Container(
      height: 300,
      width: 480,
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: getShops(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Text('');
          } else {
            if (snapshot.data == null) {
              return Text('');
            } else {
              final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return userSearchItemsName.contains(documentSnapshot['badgeNum']);
              }).toList();
              return Container(
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: Key('item ${userList[index]["badgeNum"]}'),
                      background: Container(
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Remove from the list', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(
                            () {
                              userSearchItemsName.remove(userList[index]["badgeNum"]);
                              userSearchItemsx.remove(userList[index]["fullName"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        } else {
                          setState(
                            () {
                              userSearchItemsName.remove(userList[index]["badgeNum"]);
                              userSearchItemsx.remove(userList[index]["fullName"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        }
                        setState(() {
                          if (userSearchItemsName.isEmpty) {
                            _firstShow = false;
                          }
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 18.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                    backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                  ),
                                ),
                                title: Text(userList[index]["badgeNum"]),
                                subtitle: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          userList[index]["fullName"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

//done
  _showSearchList() {
    return Container(
      height: 300,
      width: 480,
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: getShops(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Text('');
          } else {
            if (snapshot.data == null) {
              return Text('');
            } else {
              final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return userSearchArrestName.contains(documentSnapshot['badgeNum']);
              }).toList();
              return Container(
                child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: Key('item ${userList[index]["badgeNum"]}'),
                      background: Container(
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Remove from the list', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(
                            () {
                              userSearchArrestName.remove(userList[index]["badgeNum"]);
                              userSearchArrestx.remove(userList[index]["fullName"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        } else {
                          setState(
                            () {
                              userSearchArrestName.remove(userList[index]["badgeNum"]);
                              userSearchArrestx.remove(userList[index]["fullName"]);
                              userAll2.remove(userList[index]["badgeNum"]);
                              userAll3.remove(userList[index]["badgeNum"]);
                              userAll4.remove(userList[index]["badgeNum"]);
                              userAll.remove(userList[index]["badgeNum"]);
                            },
                          );
                        }
                        setState(() {
                          if (userSearchArrestName.isEmpty) {
                            _secondShow = false;
                          }
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 18.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                    backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                  ),
                                ),
                                title: Text(userList[index]["badgeNum"]),
                                subtitle: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          userList[index]["fullName"].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

//done
  void _showModalBlock() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () {
            return null;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Stack(
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
                              "Add Membersz",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {});
                                mystate(() {});
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Icon(Icons.check, size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 285.0),
                          child: Row(
                            children: [
                              Text(
                                "Checked : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                userSearchBlockName.length.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: 300,
                            width: 480,
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: getShops(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotx) {
                                if (snapshotx.hasError) {
                                  return Text('');
                                } else if (snapshotx.connectionState == ConnectionState.done) {
                                  return Text('');
                                } else {
                                  if (snapshotx.data == null) {
                                    return Text('');
                                  } else {
                                    userFinalItemsArrestSecurityForBlock = userFinalItemsArrestForSecurity + userSearchSecurityName;
                                    final List<DocumentSnapshot> userList = snapshotx.data.docs.where((DocumentSnapshot documentSnapshot) {
                                      return !userAll4.contains(documentSnapshot['badgeNum']);
                                    }).toList();
                                    // final int cardLength = userList.length;
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userList.length,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card =
                                          //     userList[index];
                                          return Dismissible(
                                            key: Key('item ${userList[index]["badgeNum"]}'),
                                            background: Container(
                                              color: Colors.greenAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite, color: Colors.white),
                                                    Text('Add to list', style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissed: (DismissDirection direction) {
                                              if (direction == DismissDirection.startToEnd) {
                                                print("Add to favorite");
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchBlockName.add(userList[index]["badgeNum"]);
                                                      userSearchBlockx.add(userList[index]["fullName"]);
                                                      userAll.add(userList[index]["badgeNum"]);
                                                      userAll3.add(userList[index]["badgeNum"]);
                                                      userAll4.add(userList[index]["badgeNum"]);
                                                      userAll2.add(userList[index]["badgeNum"]);
                                                      _fourthShow = true;
                                                      _isButx5 = true;
                                                      _isButx6 = true;
                                                      _isButx7 = true;
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchBlockName.add(userList[index]["badgeNum"]);
                                                      userSearchBlockx.add(userList[index]["fullName"]);
                                                      userAll.add(userList[index]["badgeNum"]);
                                                      userAll3.add(userList[index]["badgeNum"]);
                                                      userAll4.add(userList[index]["badgeNum"]);
                                                      userAll2.add(userList[index]["badgeNum"]);
                                                      _fourthShow = true;
                                                      _isButx5 = true;
                                                      _isButx6 = true;
                                                      _isButx7 = true;
                                                    },
                                                  );
                                                });
                                              }
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 18.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                                        // child: CircleAvatar(
                                                        //   backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                                        // ),
                                                        child: CircleAvatar(
                                                          backgroundImage: NetworkImage(userList[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userList[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userList[index]["fullName"].toString(),
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

//done
  void _showModalSecurity() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () {
            return null;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Stack(
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
                              "Add Membersy",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {});
                                mystate(() {});
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Icon(Icons.check, size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 285.0),
                          child: Row(
                            children: [
                              Text(
                                "Checked : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                userSearchSecurityName.length.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: 300,
                            width: 480,
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: getShops(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotx) {
                                if (snapshotx.hasError) {
                                  return Text('');
                                } else if (snapshotx.connectionState == ConnectionState.done) {
                                  return Text('');
                                } else {
                                  if (snapshotx.data == null) {
                                    return Text('');
                                  } else {
                                    userFinalItemsArrestForSecurity = userSearchItemsName + userSearchArrestName;
                                    final List<DocumentSnapshot> userList = snapshotx.data.docs.where((DocumentSnapshot documentSnapshot) {
                                      return !userAll3.contains(documentSnapshot['badgeNum']);
                                    }).toList();
                                    // final int cardLength = userList.length;
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userList.length,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card =
                                          //     userList[index];
                                          return Dismissible(
                                            key: Key('item ${userList[index]["badgeNum"]}'),
                                            background: Container(
                                              color: Colors.greenAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite, color: Colors.white),
                                                    Text('Add to list', style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissed: (DismissDirection direction) {
                                              if (direction == DismissDirection.startToEnd) {
                                                print("Add to favorite");
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchSecurityName.add(userList[index]["badgeNum"]);
                                                      userSearchSecurityx.add(userList[index]["fullName"]);
                                                      // userFinalItemsArrestForSecurity.add(userList[index]["badgeNum"]);
                                                      userAll.add(userList[index]["badgeNum"]);
                                                      userAll3.add(userList[index]["badgeNum"]);
                                                      userAll4.add(userList[index]["badgeNum"]);
                                                      userAll2.add(userList[index]["badgeNum"]);

                                                      _thirdShow = true;
                                                      _isButx4 = true;
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchSecurityName.add(userList[index]["badgeNum"]);
                                                      userSearchSecurityx.add(userList[index]["fullName"]);

                                                      // userFinalItemsArrestForSecurity.add(userList[index]["badgeNum"]);
                                                      userAll.add(userList[index]["badgeNum"]);
                                                      userAll3.add(userList[index]["badgeNum"]);
                                                      userAll4.add(userList[index]["badgeNum"]);
                                                      userAll2.add(userList[index]["badgeNum"]);
                                                      _thirdShow = true;
                                                      _isButx4 = true;
                                                    },
                                                  );
                                                });
                                              }
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 18.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                                          backgroundImage: NetworkImage(userList[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userList[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userList[index]["fullName"].toString(),
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

//done
  void _showModalSheetSearch() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () {
            return null;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Stack(
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
                              "Add Membersx",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {});
                                mystate(() {});
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Icon(Icons.check, size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 285.0),
                          child: Row(
                            children: [
                              Text(
                                "Checked : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                userSearchArrestName.length.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: 300,
                            width: 480,
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: getShops(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotx) {
                                if (snapshotx.hasError) {
                                  return Text('');
                                } else if (snapshotx.connectionState == ConnectionState.done) {
                                  return Text('');
                                } else {
                                  if (snapshotx.data == null) {
                                    return Text('');
                                  } else {
                                    List<DocumentSnapshot> userListx = snapshotx.data.docs.where((DocumentSnapshot documentSnapshot) {
                                      return !userAll2.contains(documentSnapshot['badgeNum']);
                                    }).toList();
                                    final int cardLength = userListx.length;
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: cardLength,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card =
                                          //     userList[index];
                                          return Dismissible(
                                            key: Key('item ${userListx[index]["badgeNum"]}'),
                                            background: Container(
                                              color: Colors.greenAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite, color: Colors.white),
                                                    Text('Add to list', style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissed: (DismissDirection direction) {
                                              if (direction == DismissDirection.startToEnd) {
                                                print("Add to favorite");
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchArrestName.add(userListx[index]["badgeNum"]);
                                                      userSearchArrestx.add(userListx[index]["fullName"]);
                                                      userAll.add(userListx[index]["badgeNum"]);
                                                      userAll3.add(userListx[index]["badgeNum"]);
                                                      userAll4.add(userListx[index]["badgeNum"]);
                                                      userAll2.add(userListx[index]["badgeNum"]);
                                                      _secondShow = true;
                                                      _isButx3 = true;
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchArrestName.add(userListx[index]["badgeNum"]);
                                                      userSearchArrestx.add(userListx[index]["fullName"]);
                                                      userAll.add(userListx[index]["badgeNum"]);
                                                      userAll3.add(userListx[index]["badgeNum"]);
                                                      userAll4.add(userListx[index]["badgeNum"]);
                                                      userAll2.add(userListx[index]["badgeNum"]);
                                                      _secondShow = true;
                                                      _isButx3 = true;
                                                    },
                                                  );
                                                });
                                              }
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 18.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                                          backgroundImage: NetworkImage(userListx[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userListx[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userListx[index]["fullName"].toString(),
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

//done
  void _showModalSheet() {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () {
            return null;
          },
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Stack(
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
                              "Add Members",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {});
                                mystate(() {});
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Container(
                                  constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Icon(Icons.check, size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 285.0),
                          child: Row(
                            children: [
                              Text(
                                "Checked : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                userSearchItemsName.length.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: 300,
                            width: 480,
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: getShops(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('');
                                } else if (snapshot.connectionState == ConnectionState.done) {
                                  return Text('');
                                } else {
                                  if (snapshot.data == null) {
                                    return Text('');
                                  } else {
                                    // final int cardLength = snapshot.data.docs.length;
                                    final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                                      return !userAll.contains(documentSnapshot['badgeNum']);
                                    }).toList();
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userList.length,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card = snapshot.data.docs[index];
                                          return Dismissible(
                                            key: Key('item ${userList[index]["badgeNum"]}'),
                                            background: Container(
                                              color: Colors.greenAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite, color: Colors.white),
                                                    Text('Add to list', style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissed: (DismissDirection direction) {
                                              if (direction == DismissDirection.startToEnd) {
                                                print("Add to favorite");
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      print(userSearchItemsName.length.toString());
                                                      userSearchItemsName.add(userList[index]["badgeNum"]);
                                                      userSearchItemsx.add(userList[index]["fullName"]);
                                                      userAll2.add(userList[index]["badgeNum"]);
                                                      userAll3.add(userList[index]["badgeNum"]);
                                                      userAll4.add(userList[index]["badgeNum"]);
                                                      userAll.add(userList[index]["badgeNum"]);
                                                      _firstShow = true;
                                                      _isButx2 = true;
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      print(userSearchItemsName.length.toString());
                                                      userSearchItemsName.add(userList[index]["badgeNum"]);
                                                      userSearchItemsx.add(userList[index]["fullName"]);
                                                      userAll2.add(userList[index]["badgeNum"]);
                                                      userAll3.add(userList[index]["badgeNum"]);
                                                      userAll4.add(userList[index]["badgeNum"]);
                                                      userAll.add(userList[index]["badgeNum"]);
                                                      _firstShow = true;
                                                      _isButx2 = true;
                                                    },
                                                  );
                                                });
                                              }
                                              // mystate(() {
                                              //   userList.removeAt(index);
                                              // });
                                              // setState(() {
                                              //   // userList.removeAt(index);
                                              //   userAll.removeAt(userList[index]["badgeNum"]);
                                              // });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 18.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
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
                                                          backgroundImage: NetworkImage(userList[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userList[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userList[index]["fullName"].toString(),
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  _buildTeam() {
    return StreamBuilder<QuerySnapshot>(
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
              List<String> listitems = ["Spotter", "Spokesperson", "Patrolman"];
              final List<DocumentSnapshot> leaderList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return !listitems.contains(documentSnapshot['position']);
              }).toList();

              List<String> listitems1 = ["Leader", "Spokesperson", "Patrolman"];
              final List<DocumentSnapshot> spotterList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return !listitems1.contains(documentSnapshot['position']);
              }).toList();

              List<String> listitems2 = ["Leader", "Spotter", "Patrolman"];
              final List<DocumentSnapshot> spokespersonList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                return !listitems2.contains(documentSnapshot['position']);
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 0.0, top: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Team Leader"),
                              DropdownButton<String>(
                                items: leaderList.map((DocumentSnapshot document) {
                                  return new DropdownMenuItem<String>(
                                    value: document["fullName"].toString(),
                                    child: Text(document["fullName"].toString()),
                                  );
                                }).toList(),
                                value: dropdownValue,
                                hint: new Text("Team Leader"),
                                elevation: 16,
                                isExpanded: true,
                                underline: Container(
                                  height: 2,
                                  color: Color(0xff93F9B9),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    print(dropdownValue.toString());
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0, left: 15, top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Spotter"),
                              DropdownButton<String>(
                                items: spotterList.map((DocumentSnapshot document) {
                                  return new DropdownMenuItem<String>(
                                    value: document["fullName"].toString(),
                                    child: Text(document["fullName"].toString()),
                                  );
                                }).toList(),
                                value: dropdownValuex,
                                hint: new Text("Spotter"),
                                elevation: 16,
                                isExpanded: true,
                                underline: Container(
                                  height: 2,
                                  color: Color(0xff93F9B9),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValuex = newValue;
                                    print(dropdownValuex.toString());
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0, left: 15, top: 20, bottom: 40),
                    child: Row(
                      children: [
                        Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Spokesperson"),
                              DropdownButton<String>(
                                items: spokespersonList.map((DocumentSnapshot document) {
                                  return new DropdownMenuItem<String>(
                                    value: document["fullName"].toString(),
                                    child: Text(document["fullName"].toString()),
                                  );
                                }).toList(),
                                value: dropdownValuey,
                                hint: new Text("Spokesperson"),
                                elevation: 16,
                                isExpanded: true,
                                underline: Container(
                                  height: 2,
                                  color: Color(0xff93F9B9),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValuey = newValue;
                                    print(dropdownValuey.toString());
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        });
  }

  _buildDateTime() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 140),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  // _showModalSecurity();
                  // _onTap();
                  // handleSignIn();
                  DatePicker.showDatePicker(context, showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
                    print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    var outputFormat = DateFormat('MM-dd-yyyy');
                    var outputDate = outputFormat.format(date);

                    setState(() {
                      finalDate = outputDate;

                      _sixthShow = true;
                      // _seventhShow = true;
                      _isButx5 = true;
                      _isButx6 = true;
                      print('confirm $date');
                    });
                  }, currentTime: DateTime.now());
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildStartTime() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 140),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  // _showModalSecurity();
                  // _onTap();
                  // handleSignIn();
                  DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
                    print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    var outputFormat2 = DateFormat('MM-dd-yyyy HH:mm a');
                    var outputDate2 = outputFormat2.format(date);
                    setState(() {
                      startTime = outputDate2;
                      _seventhShow = true;
                      // _eightShow = true;
                      _isButx7 = true;
                      print('confirm $date');
                    });
                  }, currentTime: DateTime.now());
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildEndTime() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 140),
      child: Container(
        // color: Colors.transparent,
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 50.0, // soften the shadow
              spreadRadius: 15.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: 30,
        width: 30,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  // _showModalSecurity();
                  // _onTap();
                  // handleSignIn();

                  DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
                    print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    var outputFormat2 = DateFormat('MM-dd-yyyy HH:mm a');
                    var outputDate2 = outputFormat2.format(date);
                    setState(() {
                      _eightShow = true;

                      endTime = outputDate2;
                      if (endTime.compareTo(startTime) < 0) {
                        print("hindi ito pwede");
                        endTime = "";
                        _showErrorAlert(
                            title: "Time Failed",
                            content: "End time should be after Start time!", //show error firebase
                            onPressed: _changeBlackVisible,
                            context: context);
                      }
                      print('confirm $date');
                    });
                  }, currentTime: DateTime.now());
                }, //only after checking
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showFinalTime() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Container(
        height: 30,
        width: 480,
        color: Colors.white,
        child: Center(
          child: Text(
            finalDate.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Nunito-Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _showStartTime() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Container(
        height: 30,
        width: 480,
        color: Colors.white,
        child: Center(
          child: Text(
            startTime.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Nunito-Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _showEndTime() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Container(
        height: 30,
        width: 480,
        color: Colors.white,
        child: Center(
          child: Text(
            endTime.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Nunito-Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 130),
                      child: Text(
                        "Set Schedule",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 200),
                      child: Text(
                        "Main Team",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildTeam(),
                  ],
                ),
              ),

              // Container(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 120.0, left: 190),
              //     child: _buildLoginBtn(),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain2() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 0, left: 5, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Investigation Sub-Team",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _isButx1 ? _buildInvestSub() : Container(),
                            ],
                          ),
                          _firstShow ? _showApprovedListx() : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 120.0, left: 190),
              //     child: _buildLoginBtn(),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain3() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 5, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Search/Arresting Sub-Team",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _isButx2 ? _buildSearchSub() : Container(),
                            ],
                          ),
                          _secondShow ? _showSearchList() : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain4() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 0, left: 5, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Security Sub-Team",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _isButx3 ? _buildSecuritySub() : Container(),
                            ],
                          ),
                          _thirdShow ? _showSecurityList() : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain5() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 5, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Block/Pursue Sub-Team",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _isButx4 ? _buildBlockSub() : Container(),
                            ],
                          ),
                          _fourthShow ? _showBlockList() : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain6() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                height: 200,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 0, bottom: 0),
                      child: Row(
                        children: [
                          Text(
                            "Notes",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
                      child: TextField(
                        controller: _notesTextController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(hintText: "Tap to write..."),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain7() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 0, left: 5, bottom: 50),
                      child: Column(
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(right: 70.0),
                          //       child: Text(
                          //         "Date",
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 20.0,
                          //           fontFamily: 'Nunito-Bold',
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //     _isButx5 ? _buildDateTime() : Container(),
                          //   ],
                          // ),
                          // _sixthShow ? _showFinalTime() : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    "Start Time",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _isButx6 ? _buildStartTime() : Container(),
                              ],
                            ),
                          ),
                          _seventhShow ? _showStartTime() : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 28.0),
                                  child: Text(
                                    "End Time",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _isButx7 ? _buildEndTime() : Container(),
                              ],
                            ),
                          ),
                          _eightShow ? _showEndTime() : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMain8() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 0, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Kind",
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
                          CheckboxGroup(
                            labels: <String>[
                              "Haste",
                              "Planned",
                            ],
                            checked: _checked,
                            onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
                            onSelected: (List selected) => setState(() {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                              if (selected.length > 1) {
                                selected.removeAt(0);
                                print('selected length  ${selected.length}');
                              } else {
                                print("only one");
                              }
                              _checked = selected;
                            }),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20),
                                child: Text(
                                  "Mission Name",
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                            child: TextField(
                              maxLength: 50,
                              controller: _missionnameTextController,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                              ],
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Colors.green,
                                    icon: Icon(Icons.edit),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Mission Name',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, right: 0, left: 5, bottom: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundedLoadingButton(
                                color: Color(0xff1D976C),
                                child: Text('Schedule', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                controller: _btnController,
                                onPressed: () {
                                  //  sendData();
                                  // setState(() {
                                  //   FocusScope.of(context).requestFocus(new FocusNode());
                                  //   SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  //   showAlertDialog(context);
                                  // });
                                  String notes = _notesTextController.text;
                                  if (endTime == null ||
                                          startTime == null ||
                                          notes.isEmpty ||
                                          dropdownValue == null ||
                                          dropdownValuex == null ||
                                          dropdownValuey == null ||
                                          userSearchItemsName.isEmpty ||
                                          userSearchArrestName.isEmpty ||
                                          userSearchSecurityName.isEmpty ||
                                          userSearchBlockName.isEmpty ||
                                          _missionnameTextController.text.isBlank ||
                                          vehiclelist.isEmpty ||
                                          _checked.isEmpty ||
                                          _mapTextConroller.text.isEmpty
                                      // ||finalDate == null
                                      ) {
                                    print("empty");
                                    // finalDate.
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    _showErrorAlert(
                                        title: "SCHEDULE FAILED",
                                        content: "All fields required!", //show error firebase
                                        onPressed: _changeBlackVisible,
                                        context: context);
                                    _btnController.reset();
                                  } else {
                                    // print(dropdownValue.toString());
                                    // print(dropdownValuex.toString());
                                    // print(dropdownValuey.toString());
                                    // print(userSearchItemsName.toString());
                                    // print(userSearchArrestName.toString());
                                    // print(userSearchSecurityName.toString());
                                    // print(userSearchBlockName.toString());
                                    // print(_checked.toString());
                                    // print(finalDate.toString());
                                    // print(docTitle.toString());

                                    // docTitle = finalDate.toString();

                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    showAlertDialog(context);

                                    print("hindi");

                                    // Get.offAll(Dashboard());
                                  }
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
        ],
      ),
    );
  }

  Widget _buildMain9() {
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 0, bottom: 50),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 480,
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: getHolder(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('');
                                } else if (snapshot.connectionState == ConnectionState.done) {
                                  return Text('');
                                } else {
                                  if (snapshot.data == null) {
                                    return Text('');
                                  } else {
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (_, index) {
                                          return Dismissible(
                                            key: Key('item ${snapshot.data.docs.length}'),
                                            background: Container(
                                              color: Colors.redAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete, color: Colors.white),
                                                    Text('Remove from the list', style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            secondaryBackground: Container(
                                              color: Colors.blueAccent,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Icon(Icons.edit, color: Colors.white),
                                                    Text('Edit', style: TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissed: (DismissDirection direction) {
                                              if (direction == DismissDirection.startToEnd) {
                                                FirebaseFirestore.instance.collection("trialvehicles").doc(snapshot.data.docs[index]['plate'].toString()).delete().then((value) {
                                                  print('deleted');

                                                  vehiclelist.remove(snapshot.data.docs[index]['plate'].toString());
                                                  print(vehiclelist);
                                                });
                                                setState(
                                                  () {
                                                    print('left');
                                                  },
                                                );
                                              } else {
                                                FirebaseFirestore.instance.collection("trialvehicles").doc(snapshot.data.docs[index]['plate'].toString()).delete().then((value) {
                                                  vehiclelist.remove(snapshot.data.docs[index]['plate'].toString());
                                                  print('deleted');
                                                  print(vehiclelist);
                                                });
                                                setState(
                                                  () {
                                                    print('right');
                                                    _vehiclekindTextController.text = snapshot.data.docs[index]['kind'].toString();
                                                    _vehicleplateTextController.text = snapshot.data.docs[index]['plate'].toString();
                                                    _vehiclebrandTextController.text = snapshot.data.docs[index]['brand'].toString();
                                                    _vehiclemodelTextController.text = snapshot.data.docs[index]['model'].toString();
                                                    _vehicledescTextController.text = snapshot.data.docs[index]['desc'].toString();
                                                  },
                                                );
                                              }
                                              setState(() {
                                                if (userSearchBlockName.isEmpty) {
                                                  _fourthShow = false;
                                                }
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 18.0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      color: Colors.white,
                                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                                    ),
                                                    child: ListTile(
                                                      leading: Container(padding: EdgeInsets.all(8.0), child: Text(snapshot.data.docs[index]['plate'])
                                                          // CircleAvatar(
                                                          //   backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                                          // ),
                                                          ),
                                                      title: Text(snapshot.data.docs[index]["brand"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                snapshot.data.docs[index]["model"],
                                                                style: TextStyle(color: Colors.black),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30, left: 20.0),
                                child: Text(
                                  "Vehicle List",
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
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20),
                                child: Text(
                                  "Kind of Vehicle",
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                            child: TextField(
                              maxLength: 50,
                              controller: _vehiclekindTextController,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                              ],
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Colors.green,
                                    icon: Icon(Icons.style),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Vehicle Kind',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20),
                                child: Text(
                                  "Vehicle Plate Number",
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                            child: TextField(
                              maxLength: 50,
                              controller: _vehicleplateTextController,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                              ],
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Colors.green,
                                    icon: Icon(Icons.contact_mail),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Vehicle Plate Number',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20),
                                child: Text(
                                  "Vehicle Brand",
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                            child: TextField(
                              maxLength: 50,
                              controller: _vehiclebrandTextController,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                              ],
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Colors.green,
                                    icon: Icon(Icons.local_car_wash),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Vehicle Brand',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20),
                                child: Text(
                                  "Vehicle Model",
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                            child: TextField(
                              maxLength: 50,
                              controller: _vehiclemodelTextController,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                              ],
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Colors.green,
                                    icon: Icon(Icons.directions_car),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Vehicle Model',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0, left: 20, right: 0, bottom: 0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Vehicle Description",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
                                  child: TextField(
                                    controller: _vehicledescTextController,
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(hintText: "Tap to write..."),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            // color: Colors.transparent,
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 50.0, // soften the shadow
                                  spreadRadius: 15.0, //extend the shadow
                                  offset: Offset(
                                    0.0, // Move to right 10  horizontally
                                    0.0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                            ),
                            height: 30,
                            width: 30,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: RaisedButton(
                                    onPressed: () {
                                      String vkind = _vehiclekindTextController.text;
                                      String vplate = _vehicleplateTextController.text;
                                      String vbrand = _vehiclebrandTextController.text;
                                      String vmodel = _vehiclemodelTextController.text;
                                      String vdesc = _vehicledescTextController.text;

                                      // print(vkind);
                                      FirebaseFirestore.instance.collection("trialvehicles").doc(vplate).set({
                                        'kind': vkind,
                                        'plate': vplate,
                                        'brand': vbrand,
                                        'model': vmodel,
                                        'desc': vdesc,
                                      }).then((value) {
                                        vehiclelist.add(vplate);
                                        print(vehiclelist);
                                        _vehiclekindTextController.text = "";
                                        _vehicleplateTextController.text = "";
                                        _vehiclebrandTextController.text = "";
                                        _vehiclemodelTextController.text = "";
                                        _vehicledescTextController.text = "";
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        print('im here');
                                      });
                                      // _showModalSheet();
                                      // _onTap();
                                      // handleSignIn();
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.add, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getLocationText() async {
    var reverseSearchResult = await Nominatim.reverseSearch(
      lat: lattapnew,
      lon: lngtapnew,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );
    print('this is displayname');
    print(reverseSearchResult.displayName);
    // Location.location = reverseSearchResult.displayName;
    _mapTextConroller.text = reverseSearchResult.displayName;
    // print('this is address');
    // print(reverseSearchResult.address);
    // print('this is extratags');
    // print(reverseSearchResult.extraTags);
    // print('this is naedetails');
    // print(reverseSearchResult.nameDetails);
  }

  Widget _buildMain10() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 330.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 0, bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Location",
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
                            padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8, bottom: 18),
                            child: Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
                                child: TextField(
                                  controller: _mapTextConroller,
                                  maxLines: null,
                                  expands: true,
                                  enabled: false,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(hintText: "Location Details"),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.transparent,
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 50.0, // soften the shadow
                                  spreadRadius: 15.0, //extend the shadow
                                  offset: Offset(
                                    0.0, // Move to right 10  horizontally
                                    0.0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                            ),
                            height: 30,
                            width: 30,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: RaisedButton(
                                    onPressed: () {
                                      _showMaps(context);
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.add, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showMaps(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      context: context,
      builder: (builder) {
        return SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: true,
          minimum: const EdgeInsets.only(top: 25.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                appBar: AppBar(
                  leading: BackButton(color: Colors.white),
                  title: Text("Details", style: TextStyle(color: Colors.white)),
                  backgroundColor: Color(0xff1D976C),
                ),
                body: new FlutterMap(
                  options: new MapOptions(
                    onTap: (tapLoc) {
                      print(tapLoc.latitude.toString() + tapLoc.longitude.toString());

                      mystate(() {
                        lattap = tapLoc.latitude;
                        lngtap = tapLoc.longitude;
                        lattapnew = tapLoc.latitude;
                        lngtapnew = tapLoc.longitude;
                        setState(() {
                          getLocationText();
                        });
                      });
                    },
                    center: latLng.LatLng(15.127936526523328, 120.60236373735461),
                    zoom: 18.0,
                  ),
                  layers: [
                    new TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                    new MarkerLayerOptions(
                      markers: [
                        new Marker(
                          width: 80.0,
                          height: 80.0,
                          anchorPos: AnchorPos.align(AnchorAlign.center),
                          point: new latLng.LatLng(lattap, lngtap),
                          builder: (ctx) => new Container(
                            child: Icon(Icons.room, size: 50, color: Colors.red),
                          ),
                        ),
                      ],
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
                                      "Schedule",
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
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 20, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain10()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 25, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain2()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                width: 365,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.circular(10.0),
                                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                ),
                                                child: _isButx2 ? _buildMain3() : Container(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _isButx3 ? _buildMain4() : Container()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _isButx4 ? _buildMain5() : Container()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _isButx5 ? _buildMain7() : Container()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain6()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain9()),
                                            ),
                                          ],
                                        ),
                                        new Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child: _buildMain8()),
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
                                        MyButton(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(2), height: (menuContainerHeight) / 6, selectedIndex: 2),
                                        MyButton(text: "Reset Password of User", iconData: Icons.replay, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 3),
                                        MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(4), height: (menuContainerHeight) / 6, selectedIndex: 5),

                                        // MyButton(
                                        //     text: "Fourth",
                                        //     iconData: Icons.settings,z
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
                                        auth.signOut();
                                        Get.offAll(LogSign());
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
