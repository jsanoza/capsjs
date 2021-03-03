import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LetsTry extends StatefulWidget {
  @override
  _LetsTryState createState() => _LetsTryState();
}

class _LetsTryState extends State<LetsTry> {
  String dropdownValue;
  String dropdownValuex;
  String dropdownValuey;
  String startTime;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> allowedSpotter = [];
  List<String> allowedLeader = [];
  List<String> allowedSpokesperson = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  getShop2() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("users").snapshots();
    return qn;
  }

  getFuture() async {
    // List<String> b = [];
    // b.add('02-27-2021 21:20 PM');
    // String z = '02-28-2021 21:57 PM'; //chosen time

    QuerySnapshot getallLeader = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Leader').get();
    getallLeader.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('yes');
        } else {
          setState(() {});
          print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
          allowedLeader.add(document.data()['fullName']);
          // print(allowed4);
        }
      });
    });

    QuerySnapshot getallSpotter = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Spotter').get();
    getallSpotter.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('yes');
        } else {
          setState(() {});
          print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
          allowedSpotter.add(document.data()['fullName']);
          // print(allowed4);
        }
      });
    });

    QuerySnapshot getallSpokesperson = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Spokesperson').get();
    getallSpokesperson.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('yes');
        } else {
          setState(() {});
          print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
          allowedSpokesperson.add(document.data()['fullName']);
          // print(allowed4);
        }
      });
    });
  }

  _buildTeam() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 250.0, left: 30),
        child: Container(
          width: Get.width,
          child: StreamBuilder(
              stream: getShop2(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Text('');
                } else {
                  if (snapshot.data == null) {
                    return Text('');
                  } else {
                    List<String> listitems = ["Leader", "Spokesperson", "Patrolman"];
                    final List<DocumentSnapshot> spotterList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                      return !listitems.contains(documentSnapshot['position']);
                    }).toList();

                    // List<String> listitems2 = ["Leader", "Spokesperson", "Patrolman"];
                    final List<DocumentSnapshot> finalSpotterList = spotterList.where((DocumentSnapshot documentSnapshot) {
                      return !allowedSpotter.contains(documentSnapshot['fullName']);
                    }).toList();

                    List<String> listitems1 = ["Spotter", "Spokesperson", "Patrolman"];
                    final List<DocumentSnapshot> leaderList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                      return !listitems1.contains(documentSnapshot['position']);
                    }).toList();

                    final List<DocumentSnapshot> finalLeaderList = leaderList.where((DocumentSnapshot documentSnapshot) {
                      return !allowedLeader.contains(documentSnapshot['fullName']);
                    }).toList();

                    List<String> listitems3 = ["Leader", "Spotter", "Patrolman"];
                    final List<DocumentSnapshot> spokespersonList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                      return !listitems3.contains(documentSnapshot['position']);
                    }).toList();

                    final List<DocumentSnapshot> finalSpokerspersonList = spokespersonList.where((DocumentSnapshot documentSnapshot) {
                      return !allowedSpokesperson.contains(documentSnapshot['fullName']);
                    }).toList();

                    return Center(
                      child: Column(
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
                                        items: finalLeaderList.map((DocumentSnapshot document) {
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
                                        items: finalSpotterList.map((DocumentSnapshot document) {
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
                                        items: finalSpokerspersonList.map((DocumentSnapshot document) {
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
                      ),
                    );
                  }
                }
              }),
        ),
      ),
    );
  }

  _buildTeam2() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 250.0, left: 30),
        child: Container(
          width: Get.width,
          child: StreamBuilder(
              stream: getShop2(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Text('');
                } else {
                  if (snapshot.data == null) {
                    return Text('');
                  } else {
                    List<String> listitems = ["Leader", "Spokesperson", "Patrolman"];
                    final List<DocumentSnapshot> spotterList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                      return !listitems.contains(documentSnapshot['position']);
                    }).toList();

                    // List<String> listitems2 = ["Leader", "Spokesperson", "Patrolman"];
                    final List<DocumentSnapshot> finalSpotterList = spotterList.where((DocumentSnapshot documentSnapshot) {
                      return !allowedSpotter.contains(documentSnapshot['fullName']);
                    }).toList();

                    List<String> listitems1 = ["Spotter", "Spokesperson", "Patrolman"];
                    final List<DocumentSnapshot> leaderList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                      return !listitems1.contains(documentSnapshot['position']);
                    }).toList();

                    final List<DocumentSnapshot> finalLeaderList = leaderList.where((DocumentSnapshot documentSnapshot) {
                      return !allowedLeader.contains(documentSnapshot['fullName']);
                    }).toList();

                    List<String> listitems3 = ["Leader", "Spotter", "Patrolman"];
                    final List<DocumentSnapshot> spokespersonList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
                      return !listitems3.contains(documentSnapshot['position']);
                    }).toList();

                    final List<DocumentSnapshot> finalSpokerspersonList = spokespersonList.where((DocumentSnapshot documentSnapshot) {
                      return !allowedSpokesperson.contains(documentSnapshot['fullName']);
                    }).toList();

                    return Center(
                      child: Column(
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
                                        items: finalLeaderList.map((DocumentSnapshot document) {
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
                                        items: finalSpotterList.map((DocumentSnapshot document) {
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
                                        items: finalSpokerspersonList.map((DocumentSnapshot document) {
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
                      ),
                    );
                  }
                }
              }),
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

                  DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                    print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    var outputFormat2 = DateFormat('MM-dd-yyyy HH:mm a');
                    var outputDate2 = outputFormat2.format(date);
                    setState(() {
                      startTime = outputDate2;
                      allowedSpotter = [];

                      print('confirm $date');
                    });
                    getFuture();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: ListView(
          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            _buildTeam(),
            _buildStartTime(),
            _buildTeam2(),
          ],
        ),
      ),
    ));
  }
}
