import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/forcamera/cameratrial.dart';
import 'package:get_rekk/pages/forcamera/flagged.dart';
import 'package:get_rekk/pages/forcamera/withoutident.dart';
import 'package:get_rekk/pages/forusers/usersongoingdetailspagetwo.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:time_elapsed/time_elapsed.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:uuid/uuid.dart';

class UsersOngoingdetailsPagetwo extends StatefulWidget {
  @override
  _UsersOngoingdetailsPagetwoState createState() => _UsersOngoingdetailsPagetwoState();
}

class _UsersOngoingdetailsPagetwoState extends State<UsersOngoingdetailsPagetwo> {
  DateTime alert;
  TextEditingController _vehicleplateTextController;
  RoundedLoadingButtonController _btnController;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid();
  bool _isTrue = false;
  bool _blackVisible = false;
  String finalVehResult;
  bool _isFlagEmpty = false;
  bool _isScanEmpty = false;
  bool _isFoundEmpty = false;
  bool isInvolve = false;
  GlobalKey _toolTipKey = GlobalKey();
  String why;
  String whydesc;
  String whykind;
  String whymodel;
  String whybrand;
  String whyreason;
  String userlevel;

  List<String> vlistflag = [];
  List<String> vflagby = [];
  List<String> vreason = [];
  List<String> votherreason = [];
  List<String> vtime = [];

  List<String> vlistfound = [];
  List<String> vfoundby = [];
  List<String> vfoundreason = [];
  List<String> vfoundoreason = [];
  List<String> vfoundtime = [];

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

  getShop2() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<DocumentSnapshot> qn = _firestore.collection("schedule").doc(Schedule.collectionid).snapshots();
    return qn;
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
This vehicle is not on our list of vehicles.


However, there is already another officer who scanned this vehicle.
Therefore this will not be added on your list.

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
        savetoDB();
        _btnController.reset();
        Get.back();
      },
    );
    Widget flagButton = FlatButton(
      child: Text(
        "Flag",
        style: TextStyle(
          color: Colors.red,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        //show flagg here
        // Get.back();

        setState(() {
          Get.off(Flagged(
            vehicle: finalVehResult,
            wherefrom: userlevel,
          ));
        });

        _btnController.reset();
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
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Not on our list!",
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
        '''
This vehicle is not on our list of vehicles.


Please choose carefully whether to Flag this vehicle or not.

''',
        maxLines: 20,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      actions: [
        cancelButton,
        flagButton,
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

  showSomeonez2(BuildContext context) {
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
        // _btnController.reset();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Conflict", style: TextStyle(color: Colors.red)),
      content: Text(
        '''
This vehicle is on our list of vehicles of interest.


However, there is already another officer who reported this vehicle.
Therefore this will not be added on your list.

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

  interest() async {
    User user = auth.currentUser;
    String plate = finalVehResult;
    String finalUser;
    String finalRank;
    List<String> listplate = [];
    listplate.add(plate);
    List<String> alluid = [];
    var collectionid2 = uuid.v1();
    List<String> scannedby = [];
    QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    usernamex.docs.forEach((document) {
      finalUser = document.data()['fullName'];
      finalRank = document.data()['rank'];
    });
    scannedby.add(plate + ' found by: ' + ' ' + finalRank + ' ' + finalUser);
    QuerySnapshot username = await FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: Schedule.collectionid.toString()).where('vointerest', arrayContains: plate).get();
    username.docs.forEach((document) {
      print('true' + 'MERON NA NITO SA DB BRO');
      _isTrue = true;
    });

    if (_isTrue == true) {
      print('show alert that there is already a scanned vehicle with this plate number!');
      showSomeonez2(context);
    } else {
      QuerySnapshot check = await FirebaseFirestore.instance.collection('users').where('collectionId', isNotEqualTo: 'dummy').get();
      check.docs.forEach((document) async {
        alluid.add(document.data()['collectionId'].toString());
      });

      //else add the plate to the list in the schedule
      QuerySnapshot getVehicleDetails = await FirebaseFirestore.instance.collection('vehicles').where('query', isEqualTo: finalVehResult).get();
      getVehicleDetails.docs.forEach((document) {
        FirebaseFirestore.instance.collection('found').doc(finalVehResult).set({
          'foundby': FieldValue.arrayUnion(scannedby),
          'foundtime': Timestamp.now(),
          'query': finalVehResult,
          'foundwhere': Schedule.missionname.toString(),
          'foundwhereid': Schedule.collectionid,
          'vehicle': document.data()['vehicle'],
          'addedby': document.data()['addedby'],
          "reason": document.data()['reason'],
          "vehiclebrand": document.data()['vehiclebrand'],
          "vehicledesc": document.data()['vehicledesc'],
          "vehiclekind": document.data()['vehiclekind'],
          "vehiclemodel": document.data()['vehiclemodel'],
          "timestamp": document.data()['addedtime'],
        }).then((value) {
          FirebaseFirestore.instance.collection('vehicles').doc(finalVehResult).delete();
        }).then((valuex) {
          FirebaseFirestore.instance.collection("schedule").doc(Schedule.collectionid.toString()).update({
            'vointerest': FieldValue.arrayUnion(listplate),
            'voilast': FieldValue.arrayUnion(scannedby),
          }).then((value) {
            FirebaseFirestore.instance.collection('flag').doc(listplate.toString()).set({
              'flaggedvehicles': FieldValue.arrayUnion(listplate),
              'lastflag': FieldValue.arrayUnion(scannedby),
              'collectionid': Schedule.collectionid,
              'reason': 'Found a vehicle on our vehicles of interests list!',
              'otherreason': 'Assistance needed!',
              'seen': FieldValue.arrayUnion(alluid),
            }).then((value) async {
              //add to sub document
              FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).collection('vointerest').doc(plate.toString()).set({
                'scannedvehicles': FieldValue.arrayUnion(listplate),
                'whoscanned': user.uid,
                'scannedtime': Timestamp.now(),
                'scannedby': user.uid,
              }).then((value) {
                //add to users document
                FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(Schedule.collectionid).collection('vointerest').doc(plate).set({
                  'scannedvehicles': plate,
                  'query': plate,
                  'scannedtime': Timestamp.now(),
                }).then((value) {
                  //add to usertrail
                  FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('schedscan').doc(collectionid2).set({
                    'userid': user.uid,
                    'this_collectionid': collectionid2,
                    'activity': 'Found a vehicle of interest with plate number: $plate',
                    'editcreate_datetime': Timestamp.now(),
                    'editcreate_collectionid': Schedule.collectionid,
                    'vehicle': plate,
                  });
                });
              });
            });
          });
        });
      });
      // FirebaseFirestore.instance.collection("schedule").doc(Schedule.collectionid.toString()).update({
      //   'vointerest': FieldValue.arrayUnion(listplate),
      //   'voilast': FieldValue.arrayUnion(scannedby),
      // }).then((value) {
      //   FirebaseFirestore.instance.collection('flag').doc(listplate.toString()).set({
      //     'flaggedvehicles': FieldValue.arrayUnion(listplate),
      //     'lastflag': FieldValue.arrayUnion(scannedby),
      //     'collectionid': Schedule.collectionid,
      //     'reason': 'Found a vehicle on our vehicle of interest list!',
      //     'otherreason': 'Assistance needed!',
      //     'seen': FieldValue.arrayUnion(alluid),
      //   }).then((value) async {
      //     //add to sub document
      //     FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).collection('vointerest').doc(plate.toString()).set({
      //       'scannedvehicles': FieldValue.arrayUnion(listplate),
      //       'whoscanned': user.uid,
      //       'scannedtime': Timestamp.now(),
      //       'scannedby': user.uid,
      //     }).then((value) {
      //       //add to users document
      //       FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(Schedule.collectionid).collection('vointerest').doc(plate).set({
      //         'scannedvehicles': plate,
      //         'query': plate,
      //         'scannedtime': Timestamp.now(),
      //       }).then((value) {
      //         //add to usertrail
      //         FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('schedscan').doc(collectionid2).set({
      //           'userid': user.uid,
      //           'this_collectionid': collectionid2,
      //           'activity': 'Found a vehicle of interest with plate number: $plate',
      //           'editcreate_datetime': Timestamp.now(),
      //           'editcreate_collectionid': Schedule.collectionid,
      //           'vehicle': plate,
      //         });
      //       });
      //     });
      //   });
      // });
      _showSuccessAlert(
          title: "Success!",
          content: "Added!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      // _vehicleplateTextController.text = '';
    }
  }

  showInterestDialog(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text(
        "Notify Now!",
        style: TextStyle(
          color: Colors.green,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        interest();
        // savetoDB();
        _btnController.reset();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "THIS VEHICLE IS ON OUR LIST!",
        style: TextStyle(color: Colors.red, fontSize: 30),
      ),
      content: Text(
        '''
THIS VEHICLE IS ON OUR LIST.


ALL OFFICERS WILL BE NOTIFIED.

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

//assume send to db on confirm
  savetoDB() async {
    User user = auth.currentUser;
    String plate = finalVehResult;
    List<String> listplate = [];
    List<String> scannedby = [];
    String finalUser;
    String finalRank;
    listplate.add(plate);
    var collectionid2 = uuid.v1();
    print(plate);
    //first get the users full name
    QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    usernamex.docs.forEach((document) {
      finalUser = document.data()['fullName'];
      finalRank = document.data()['rank'];
    });
    scannedby.add(plate + ' scanned by: ' + ' ' + finalRank + ' ' + finalUser);
    //check if vehicle is already scanned
    QuerySnapshot username = await FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: Schedule.collectionid.toString()).where('scannedvehicles', arrayContains: plate).get();
    username.docs.forEach((document) {
      print('true');
      _isTrue = true;
    });
    //show flagged here if resisting ang perpetrator
    if (_isTrue == true) {
      print('show alert that there is already a scanned vehicle with this plate number!');
      showSomeone(context);
    } else {
      //else add the plate to the list in the schedule
      FirebaseFirestore.instance.collection("schedule").doc(Schedule.collectionid.toString()).update({
        'scannedvehicles': FieldValue.arrayUnion(listplate),
        'lastscan': FieldValue.arrayUnion(scannedby),
      }).then((value) async {
        //add to sub document
        FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).collection('spot').doc(plate.toString()).set({
          'scannedvehicles': FieldValue.arrayUnion(listplate),
          'whoscanned': user.uid,
          'scannedtime': Timestamp.now(),
          'scannedby': user.uid,
        }).then((value) {
          //add to users document
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(Schedule.collectionid).collection('scannedvehicles').doc(plate).set({
            'scannedvehicles': plate,
            'query': plate,
            'scannedtime': Timestamp.now(),
          }).then((value) {
            //add to usertrail
            FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('schedscan').doc(collectionid2).set({
              'userid': user.uid,
              'this_collectionid': collectionid2,
              'activity': 'Scanned a vehicle with plate number: $plate',
              'editcreate_datetime': Timestamp.now(),
              'editcreate_collectionid': Schedule.collectionid,
              'vehicle': plate,
            });
          });
        });
      });
      _showSuccessAlert(
          title: "Success!",
          content: "Added into your scanned list!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      _vehicleplateTextController.text = '';
    }
  }

  // Future getBadge(String useruid) async {

  //   var a = await FirebaseFirestore.instance.collection('users').where("collectionId", isEqualTo: useruid).get();
  //   if (a.docs.isNotEmpty) {
  //     // print('Exists');

  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     // print('nope');
  //     return false;
  //   }
  // }

  checktoDB() async {
    String plate = finalVehResult;
    //check if the plate exists
    User user = auth.currentUser;
    String useruid = user.uid.toString();
    var usercheck;
    var a = await FirebaseFirestore.instance.collection('vehicles').where("vehicle", isEqualTo: plate).get();
    // var b = await FirebaseFirestore.instance.collection('userlevel').where('collectionid', isEqualTo: '').get();
    // var badgeCheck = await getBadge(useruid);

    QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: useruid).get();
    username.docs.forEach((document) {
      usercheck = document.data()['badgeNum'].toString();
    });

    QuerySnapshot getLevel = await FirebaseFirestore.instance.collection('userlevel').where('badgeNum', isEqualTo: usercheck).get();
    getLevel.docs.forEach((document) {
      userlevel = document.data()['level'].toString();
    });

    //condition it
    if (a.docs.isNotEmpty) {
      print('Exists');
      //if plate exists sa vehicle wanted list //alert now!
      showInterestDialog(context);
      _btnController.reset();
      return true;
    }

    //another condition
    if (a.docs.isEmpty) {
      _isTrue = false;
      setState(() {
        showAlertDialog(context);
      });

      _btnController.reset();
      print('nope');
      return false;
    }
  }

  @override
  void initState() {
    _vehicleplateTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    _isFlagEmpty = false;
    _isScanEmpty = false;
    if (Schedule.vehicle.isNotEmpty) {
      isInvolve = true;
    } else {
      isInvolve = false;
    }

    super.initState();
  }

  void _showModalSheet() {
    FocusScope.of(context).requestFocus(new FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    String pattern = r"^[A-Z]{0,4}[\s]*[0-9]{0,5}$";
    RegExp regEx = RegExp(pattern);
    _vehicleplateTextController.text = '';
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
                height: 500,
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
                                "Via Input",
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
                                  "Vehicle Plate Number",
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
                            padding: EdgeInsets.only(bottom: 20, left: 40, right: 40, top: 20),
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              controller: _vehicleplateTextController,
                              maxLength: 10,
                              maxLengthEnforced: true,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                              ],
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
                                  hintText: 'Vehicle Plate Number',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
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
                                      color: Color(0xff085078),
                                      child: Text('Check', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                      controller: _btnController,
                                      onPressed: () async {
                                        // if (regEx.hasMatch(_vehicleplateTextController.text.toUpperCase())) {
                                        //   if (_vehicleplateTextController.text.contains(" ")) {
                                        //     print('passed!');
                                        //     checktoDB();
                                        //   } else {
                                        //     print('no');
                                        //     _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                        //   }

                                        //   _btnController.reset();
                                        // } else {
                                        //   print('no');
                                        //   _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                        //   _btnController.reset();
                                        // }

                                        String result = _vehicleplateTextController.text.toUpperCase().substring(0, _vehicleplateTextController.text.toUpperCase().indexOf(' '));
                                        print(result);
                                        String s1 = _vehicleplateTextController.text.substring(_vehicleplateTextController.text.indexOf(" ") + 1);
                                        print(s1);

                                        String characters = "[a-zA-Z]";
                                        RegExp regChar = RegExp(characters);
                                        String digits = "[0-9]";
                                        RegExp regDig = RegExp(digits);

                                        if (regChar.hasMatch(result)) {
                                          print('ok');
                                          if (result.length < 3) {
                                            print('ok but less than 3');
                                            //pag less than 3 that means mc sya and kailangan dapat ung digit is 5 digits
                                            //check if ung digits is 5
                                            if (regDig.hasMatch(s1)) {
                                              print('ok numbers sya.');
                                              if (s1.length == 5) {
                                                print('ok 5 digits sya');
                                                setState(() {
                                                  finalVehResult = result + " " + s1;
                                                  checktoDB();
                                                });

                                                print('this is the final result');
                                                // print(finalMCResult);
                                              } else {
                                                //error kase hindi naman sya 5 digits.
                                                print('hindi sya 5 digits not valid');
                                                _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                                _btnController.reset();
                                              }
                                            } else {
                                              //error kase may letters sa dapat na digit lang
                                              _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                              _btnController.reset();
                                            }
                                          } else {
                                            if (result.length == 3) {
                                              print('ok kotse sya');
                                              if (regDig.hasMatch(s1)) {
                                                print('ok number sya');
                                                if (s1.length == 4) {
                                                  setState(() {
                                                    finalVehResult = result + " " + s1;
                                                    checktoDB();
                                                  });
                                                  print('this is the final result');
                                                  print(finalVehResult);
                                                } else {
                                                  print('kulang or sobra ang number');
                                                  _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                                  _btnController.reset();
                                                }
                                              } else {
                                                print('hindi sya number');
                                                _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                                _btnController.reset();
                                              }
                                            } else {
                                              print('lagpas sa 3');
                                              _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                              _btnController.reset();
                                            }
                                          }
                                        } else {
                                          _showErrorAlert(title: "INPUT FAILED", content: "Please enter a valid License Plate. \n Example: ABC 1234 / MC 12345", onPressed: _changeBlackVisible, context: context);
                                          print('no');
                                          _btnController.reset();
                                        }

                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        print("hindi");
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

  fetchVehicleInfo(String index) async {
    QuerySnapshot search = await FirebaseFirestore.instance.collection('vehicles').where('query', isEqualTo: index).get();
    search.docs.forEach((element) {
      why = element.data()['query'];
      whydesc = element.data()['vehicledesc'];
      whykind = element.data()['vehiclekind'];
      whymodel = element.data()['vehiclemodel'];
      whybrand = element.data()['vehiclebrand'];
      whyreason = element.data()['reason'];
      print(element.data()['query']);
    });

    showAlertDialog(BuildContext context) {
      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed: () {
          // sendData();
          Get.back();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(index),
        content: Text(
          '''
The given description for this vehicle:
$whydesc


With the following specification: 
$whykind
$whybrand
$whymodel


Reason:
$whyreason
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
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }

  fetchVehicleInfoFlag(String index) async {
    String flagreason;
    String otherflagreason;
    String lastflagreason;
    String flagvehicle;
    String flaggedby;
    DateTime timeofflag;
    QuerySnapshot search = await FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid).collection('flagged').where('scannedvehicles', arrayContains: index).get();

    search.docs.forEach((element) {
      flaggedby = element.data()['flaggedby'];
      otherflagreason = element.data()['otherreason'];
      flagreason = element.data()['reason'];
      flagvehicle = element.data()['scannedvehicles'].toString();
      timeofflag = element.data()['scannedtime'].toDate();
      // whybrand = element.data()['vehiclebrand'];
      // whyreason = element.data()['reason'];
      // print(element.data()['query']);
    });

    showAlertDialog(BuildContext context) {
      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed: () {
          // sendData();
          Get.back();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(index),
        content: Text(
          '''

  The vehicle with plate number:
  $flagvehicle
  was flagged by:
  $flaggedby

  with the reasoning of:
  $flagreason
  $otherflagreason

  Time of flagging was:
  $timeofflag
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
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }

  showAlertDialogQFlag(BuildContext context) {
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        vlistflag = [];
        vflagby = [];
        vreason = [];
        votherreason = [];
        vtime = [];
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Flagged List'),
      content: Container(
        height: 300,
        width: Get.width,
        child: ListView.builder(
            itemCount: vlistflag.length,
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
                          // leading: Container(
                          //   padding: EdgeInsets.all(8.0),
                          //   // child: CircleAvatar(
                          //   //   backgroundImage: NetworkImage(vlist[index]),
                          //   // ),
                          //   child: Text(vlistflag[index]),
                          // ),
                          title: Text(vlistflag[index]),
                          subtitle: Text(vflagby[index]),
                          onTap: () {
                            String string = vlistflag[index].toString().replaceAll('[', '');
                            String finalString = string.replaceAll(']', '');

                            fetchVehicleInfoFlag(finalString);
                          },
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

  fetchVehicleListFlag() async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid).collection('flagged').get();

    snap.docs.forEach((document) {
      print(document.id);
      vlistflag.add(document.data()['scannedvehicles'].toString());
      vflagby.add(document.data()['flaggedby'].toString());
      vreason.add(document.data()['reason'].toString());
      votherreason.add(document.data()['otherreason'].toString());
      vtime.add(document.data()['scannedtime'].toDate().toString());
    });
    setState(() {});
    showAlertDialogQFlag(context);
  }

  fetchVehicleInfoFound(String index) async {
    print(index);
    String why;
    String whydesc;
    String whykind;
    String whymodel;
    String whybrand;
    String whyreason;
    List<String> foundby = [];
    String foundwhere;
    String foundtime;
    QuerySnapshot search = await FirebaseFirestore.instance.collection('found').where('query', isEqualTo: index).get();

    search.docs.forEach((element) {
      why = element.data()['query'];
      whydesc = element.data()['vehicledesc'];
      whykind = element.data()['vehiclekind'];
      whymodel = element.data()['vehiclemodel'];
      whybrand = element.data()['vehiclebrand'];
      whyreason = element.data()['reason'];
      // foundby = element.data()['foundby'];
      foundby.add(element.data()['foundby'].toString());
      foundwhere = element.data()['foundwhere'];
      foundtime = element.data()['foundtime'].toDate().toString();
      print(element.data()['query']);
      // whybrand = element.data()['vehiclebrand'];
      // whyreason = element.data()['reason'];
      // print(element.data()['query']);
    });

    showAlertDialog(BuildContext context) {
      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed: () {
          // sendData();
          Get.back();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(index),
        content: Text(
          '''

The given description for this vehicle:
$whydesc


With the following specification: 
$whykind
$whybrand
$whymodel


Vehicle was found by:
$foundby
While on the mission: 
$foundwhere
at:
$foundtime
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
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }

showAlertDialogQFound(BuildContext context) {
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        vlistfound = [];
        vfoundby = [];
        vfoundreason = [];
        vfoundoreason = [];
        vfoundtime = [];
        Get.back();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Found List'),
      content: Container(
        height: 300,
        width: Get.width,
        child: ListView.builder(
            itemCount: vlistfound.length,
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
                          // leading: Container(
                          //   padding: EdgeInsets.all(8.0),
                          //   // child: CircleAvatar(
                          //   //   backgroundImage: NetworkImage(vlist[index]),
                          //   // ),
                          //   child: Text(vlistflag[index]),
                          // ),
                          title: Text(vlistfound[index]),
                          // subtitle: Text(vfoundby[index]),
                          onTap: () {
                            String string = vlistfound[index].toString().replaceAll('[', '');
                            String finalString = string.replaceAll(']', '');

                            fetchVehicleInfoFound(finalString);
                          },
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

  fetchVehicleListFound() async {
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid).collection('vointerest').get();

   
    snap.docs.forEach((document) {
      print(document.id);
      vlistfound.add(document.data()['scannedvehicles'].toString());
      // vfoundby.add(document.data()['scannedby'].toString());
      // List<String> vfoundreason = [];
      // vfoundreason.add(document.data()['reason'].toString());
      // vfoundoreason.add(document.data()['otherreason'].toString());
      vfoundtime.add(document.data()['scannedtime'].toDate().toString());
    });
    setState(() {});
    showAlertDialogQFound(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: Get.width,
        child: Stack(children: [
          StreamBuilder<DocumentSnapshot>(
              stream: getShop2(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Text('');
                } else {
                  if (snapshot.data == null) {
                    return Text('');
                  } else {
                    int len = snapshot.data['scannedvehicles'].length;
                    int lenflag = snapshot.data['flaggedvehicles'].length;
                    int lenvoi = snapshot.data['vointerest'].length;

                    if (snapshot.data['scannedvehicles'].length <= 0 || snapshot.data['lastscan'].length <= 0) {
                      _isScanEmpty = false;
                    } else {
                      _isScanEmpty = true;
                    }
                    if (snapshot.data['flaggedvehicles'].length <= 0 || snapshot.data['lastflag'].length <= 0) {
                      _isFlagEmpty = false;
                    } else {
                      _isFlagEmpty = true;
                    }

                    if (snapshot.data['vointerest'].length <= 0 || snapshot.data['voilast'].length <= 0) {
                      _isFoundEmpty = false;
                    } else {
                      _isFoundEmpty = true;
                    }

                    // collectid = snapshot.data['collectionid'];
                    // checkmate(snapshot.data['lastflag'].last.toString());
                    // count = lenflag;
                    // shownotif(snapshot.data['lastflag'].last.toString());

                    return new Stack(
                      children: <Widget>[
                        Padding(
                          padding: isInvolve ? const EdgeInsets.only(left: 10, right: 10, top: 470.0, bottom: 20) : const EdgeInsets.only(left: 10, right: 10, top: 270.0, bottom: 20),
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
                                        "Status",
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
                                  padding: const EdgeInsets.only(left: 18.0, top: 18),
                                  child: Row(
                                    children: [
                                      Text("Deployment active time:"),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0),
                                        child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                                          var b = DateFormat('MM-dd-yyyy HH:mm').parse(snapshot.data["starttime"].toString());
                                          final Duration myDuration = DateTime.parse(b.toString()).difference(DateTime.now());
                                          final withoutEquals = myDuration.toString().replaceAll(RegExp('-'), '');
                                          final gg = withoutEquals.toString().split('.')[0];
                                          return Text(
                                            "$gg ET",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontFamily: 'Nunito-Bold',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 50),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Scanned Vehicles",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text("Total Scanned Vehicles: ",
                                          style: TextStyle(
                                            color: Colors.green,
                                          )),
                                      Text(
                                        _isScanEmpty ? '   ' + len.toString() : '',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Last Successful Scan:',
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        _isScanEmpty ? '      ' + snapshot.data['scannedvehicles'].last.toString() : '',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        _isScanEmpty ? snapshot.data['lastscan'].last.toString() : '',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 50),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Flagged Vehicles",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.red),
                                        onPressed: () {
                                          fetchVehicleListFlag();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Total Flagged Vehicles: ",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        _isFlagEmpty ? '   ' + lenflag.toString() : '',
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
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Last Successful Flagged:',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        _isFlagEmpty ? ' ' + snapshot.data['flaggedvehicles'].last.toString() : '',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.red),
                                        onPressed: () {
                                          fetchVehicleInfoFlag(snapshot.data['flaggedvehicles'].last.toString());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        _isFlagEmpty ? snapshot.data['lastflag'].last.toString() : '',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // _buildTeam(),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 50),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Found Vehicles",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.blue),
                                        onPressed: () {
                                          // fetchVehicleListFlag();
                                          fetchVehicleListFound();

                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Total Found Vehicles: ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        _isFoundEmpty ? '   ' + lenvoi.toString() : '',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Last Found Vehicle:',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Text(
                                        _isFoundEmpty ? ' ' + snapshot.data['vointerest'].last.toString() : '',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.blue),
                                        onPressed: () {
                                          fetchVehicleInfoFound(snapshot.data['vointerest'].last.toString());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        _isFoundEmpty ? snapshot.data['voilast'].last.toString() : '',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14.0,
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
                    );
                  }
                }
              }),

          Stack(
            children: <Widget>[
              Padding(
                padding: isInvolve ? const EdgeInsets.only(left: 10.0, right: 10.0, top: 1500, bottom: 30) : const EdgeInsets.only(left: 10.0, right: 10.0, top: 920, bottom: 30),
                child: Container(
                  width: Get.width,
                  height: 400,
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
                              "Actions",
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
                        padding: const EdgeInsets.only(left: 18.0, top: 20),
                        child: Row(
                          children: [
                            Text("Compare Vehicles:"),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 30.0, right: 0.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Color(0xff085078),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green,
                                    blurRadius: 40.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      0.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: new IconButton(
                                        icon: Icon(
                                          Icons.camera_enhance,
                                          color: Colors.white,
                                        ),
                                        iconSize: 40,
                                        onPressed: () {
                                          Get.to(CameraApp());
                                          print("Google clicked");
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0, left: 40, right: 0.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Color(0xff085078),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green,
                                    blurRadius: 40.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      0.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: new IconButton(
                                        icon: Icon(
                                          Icons.border_color,
                                          color: Colors.white,
                                        ),
                                        iconSize: 40,
                                        onPressed: () {
                                          print("Google clicked");
                                          _showModalSheet();
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 30),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 0, bottom: 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Vehicle with no identifications?",
                                    style: TextStyle(
                                      color: Colors.red,
                                      // fontSize: 20.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final dynamic tooltip = _toolTipKey.currentState;
                                      tooltip.ensureTooltipVisible();
                                    },
                                    child: Tooltip(
                                      key: _toolTipKey,
                                      // ignore: missing_required_param
                                      child: IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.red),
                                      ),
                                      message: 'If a Driver failed to show any identifcations or does not have any license plate installed then:\nIt is time for human interaction, and should be personally questioned.',
                                      padding: EdgeInsets.all(20),
                                      margin: EdgeInsets.all(20),
                                      showDuration: Duration(seconds: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.9),
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      ),
                                      textStyle: TextStyle(color: Colors.white),
                                      preferBelow: true,
                                      verticalOffset: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 0, right: 0.0),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: new BoxDecoration(
                            color: Color(0xff085078),
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green,
                                blurRadius: 40.0, // soften the shadow
                                spreadRadius: 0.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  0.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: new IconButton(
                                    icon: Icon(
                                      Icons.receipt,
                                      color: Colors.white,
                                    ),
                                    iconSize: 40,
                                    onPressed: () {
                                      print("Google clicked");
                                      Get.to(WithoutIdent());
                                      // _showModalSheet();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // _buildTeam(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20, bottom: 30),
                child: Container(
                  width: Get.width,
                  height: isInvolve ? 430 : 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(10.0),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Purpose of Deployment",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                          ),
                          child: Container(
                            child: ListTile(
                              title: AutoSizeText(
                                "${Schedule.notes} ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                                minFontSize: 15,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                      isInvolve
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Vehicle Report: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Nunito-Bold',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text(''),
                      isInvolve
                          ? Padding(
                              padding: const EdgeInsets.only(left: 28.0, top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "*Tap on the Vehicle Number to see the details.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(''),
                      isInvolve
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                              child: Container(
                                height: 200,
                                width: 480,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  child: ListView.builder(
                                    itemCount: Schedule.vehicle.length,
                                    itemBuilder: (_, index) {
                                      // final DocumentSnapshot _card =
                                      //     userList[index];
                                      return Column(
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
                                                title: Text(Schedule.vehicle[index]),
                                                onTap: () async {
                                                  // print(PastSchedule.missionid.toString());
                                                  // showVehicleInfo(PastSchedule.flaggedvehicles[index]);
                                                  fetchVehicleInfo(Schedule.vehicle[index]);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //... The children inside the column of ListView.builder
        ]),
      ),
    );
  }
}
