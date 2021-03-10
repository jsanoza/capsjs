import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Flagged extends StatefulWidget {
  final String vehicle;

  const Flagged({Key key, this.vehicle}) : super(key: key);
  @override
  _FlaggedState createState() => _FlaggedState();
}

TextEditingController _notesTextController;
RoundedLoadingButtonController _btnController;
FirebaseAuth auth = FirebaseAuth.instance;
List<String> checked = [];
List<String> _checked2 = [];
bool _blackVisible = false;
bool _isTrue = false;
var uuid = Uuid();

class _FlaggedState extends State<Flagged> {
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

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text(
        "Confirm",
        style: TextStyle(
          color: Colors.green,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        saveFlag();
        _btnController.reset();
        Get.back();
      },
    );

    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        _btnController.reset();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmation",
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
        '''
Confirm that all the reason/s to believe that this vehicle should be flagged is true.


Once you clicked confirm, the system will automatically send a notification to all the officers that you have flagged a vehicle.

Are you sure you want to add this vehicle on the flagged vehicle list?


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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSomeone(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(
          color: Colors.green,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        // savetoDB();
        _btnController.reset();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Conflict", style: TextStyle(color: Colors.red)),
      content: Text(
        '''
This vehicle is not on our flagged list of vehicles.


However, there is already another officer who flagged this vehicle.
Therefore this will not be added on the flag list.

''',
        maxLines: 20,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showNotification(v, flp) async {
    var android = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flp.show(0, 'ACPRO3', '$v', platform, payload: 'ACPRO3 \n $v');
  }

  checktoDB() async {
    // String plate = _vehicleplateTextController.text.toUpperCase();
    //check if the plate exists
    var a = await FirebaseFirestore.instance.collection('vehicles').where("vehicle", isEqualTo: widget.vehicle).get();

    //condition it
    if (a.docs.isNotEmpty) {
      print('Exists');
      //if plate exists sa vehicle wanted list //alert now!
      _btnController.reset();
      return true;
    }

    //another condition
    if (a.docs.isEmpty) {
      _isTrue = false;
      setState(() {
        showAlertDialog(context);
      });

      // _btnController.reset();
      print('nope');
      return false;
    }
  }

  saveFlag() async {
    User user = auth.currentUser;
    List<String> listplate = [];
    List<String> scannedby = [];
    String finalUser;
    String finalRank;
    listplate.add(widget.vehicle);
    List<String> listuid = [];
    listuid.add(user.uid);
    List<String> alluid = [];
    var collectionid2 = uuid.v1();
    var notes = _notesTextController.text;
    var rem1 = '[';
    var rem2 = ']';
    var rem3 = ',';
    var singleline = _checked2.toString().replaceAll("\n", "");
    var formattedString = singleline.split(".").join(". \n");
    var formatagain = formattedString.replaceAll(rem1, '');
    formatagain = formatagain.replaceAll(rem2, '');
    formatagain = formatagain.replaceAll(rem3, '');
    print(formatagain);
    print(notes);
    //uppload to db
    _checked2 = [];
    // FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    // var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iOS = IOSInitializationSettings();
    // var initSetttings = InitializationSettings(android: android, iOS: iOS);
    // flp.initialize(initSetttings);

    //first get the users full name
    QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    usernamex.docs.forEach((document) {
      finalUser = document.data()['fullName'];
      finalRank = document.data()['rank'];
    });
    //check if exists sa scannedvehicles list
    scannedby.add(widget.vehicle + ' flagged by: ' + ' ' + finalRank + ' ' + finalUser);
    QuerySnapshot username = await FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: Schedule.collectionid.toString()).where('flaggedvehicles', arrayContains: widget.vehicle).get();
    username.docs.forEach((document) {
      print('true');
      _isTrue = true;
    });
    //show flagged here if resisting ang perpetrator
    if (_isTrue == true) {
      print('show alert that there is already a flagged vehicle with this plate number!');
      showSomeone(context);

      // showSomeone(context);
    } else {
      //else add the flage
      // showNotification('Officer Flagged a vehicle with plate number:', flp);

      QuerySnapshot check = await FirebaseFirestore.instance.collection('users').where('collectionId', isNotEqualTo: 'dummy').get();
      check.docs.forEach((document) async {
        alluid.add(document.data()['collectionId'].toString());
      });

      FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).update({
        'flaggedvehicles': FieldValue.arrayUnion(listplate),
        'lastflag': FieldValue.arrayUnion(scannedby),
      }).then((value) {
        FirebaseFirestore.instance.collection('flag').doc(listplate.toString()).set({
          'flaggedvehicles': FieldValue.arrayUnion(listplate),
          'lastflag': FieldValue.arrayUnion(scannedby),
          'collectionid': Schedule.collectionid,
          'reason': formatagain,
          'otherreason': notes,
          'seen': FieldValue.arrayUnion(alluid),
        }).then((value) {
          FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).collection('flagged').doc(widget.vehicle).set({
            'scannedvehicles': FieldValue.arrayUnion(listplate),
            'whoscanned': user.uid,
            'scannedtime': Timestamp.now(),
            'flaggedby': user.uid,
            'reason': formatagain,
            'otherreason': notes,
          }).then((value) {
            //add to users document
            FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(Schedule.collectionid).collection('scannedvehicles').doc(widget.vehicle).set({
              'scannedvehicles': widget.vehicle,
              'query': widget.vehicle,
              'scannedtime': Timestamp.now(),
            }).then((value) {
              //add to usertrail
              FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('schedscan').doc(collectionid2).set({
                'userid': user.uid,
                'this_collectionid': collectionid2,
                'activity': 'Flagged a vehicle with plate number: $widget.vehicle',
                'editcreate_datetime': Timestamp.now(),
                'editcreate_collectionid': Schedule.collectionid,
                'vehicle': widget.vehicle,
              });
            });
          });
        });
      });

      _showSuccessAlert(
          title: "Success!",
          content: "Added into the flagged list!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      // _vehicleplateTextController.text = '';
    }
  }

  @override
  void initState() {
    _notesTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    _checked2 = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1D976C),
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).popUntil((_) => count++ >= 2)),
          title: Text(
            "Flag",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50, bottom: 30),
                child: Container(
                  width: Get.width,
                  height: 1000,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(10.0),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 0),
                            child: Text(
                              "Flag: ",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 30.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 0),
                            child: Text(
                              widget.vehicle,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 40),
                        child: Row(
                          children: [
                            Text(
                              "Reason/s: ",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                          },
                          child: CheckboxGroup(
                            margin: const EdgeInsets.only(left: 12.0),
                            labels: <String>[
                              "The passenger/s of the vehicle\n appear/s nervous or\n suspicious or acts unnaturally.",
                              "\nHas reason to believe that the\n passenger is a lawbreaker or\n there is evidence of a crime,\n like drugs, blood stains, etc.",
                              "\nHas received a prior and reasonably\n corroborated tip on the motorist’s\n possible illegal activity.",
                              "\nDriver is under the influence of alcohol\n or drugs, or there are illegal\n substances in the vehicle.",
                              "\nThe driver or adult passenger cannot\n clearly establish his or her\n relationship with the child or\n children travelling with him or her.",
                              "\nThe driver or passenger\n is transporting\n animals without a permit.",
                              "\nThere are items that may be used for\n destruction found in the vehicle.",
                              "\n Driver fails to show a driver’s license.",
                            ],
                            onSelected: (checked) => setState(() {
                              _checked2 = checked;
                            }),
                          ),
                        ),
                      ),

                      Container(
                        width: 330.0,
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0, left: 10, right: 0, bottom: 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Other Reason/s:",
                                    style: TextStyle(
                                      color: Colors.red,
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

                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, right: 0, left: 5, bottom: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RoundedLoadingButton(
                                  color: Color(0xff1D976C),
                                  child: Text('Submit', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                  controller: _btnController,
                                  onPressed: () async {
                                    // checktoDB();
                                    if (_checked2.isEmpty == true) {
                                      _btnController.reset();
                                      _showErrorAlert(title: "FLAGGING FAILED", content: "Please choose/write a valid reason.", onPressed: _changeBlackVisible, context: context);
                                    } else {
                                      // showAlertDialog(context);
                                      checktoDB();
                                    }

                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    // print("hindi");
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // _buildTeam(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
