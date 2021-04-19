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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:intl/intl.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:osm_nominatim/osm_nominatim.dart';

import 'fourth.dart';
import '../loginsignup.dart';

class NewEditSched extends StatefulWidget {
  @override
  _NewEditSchedState createState() => _NewEditSchedState();
}

class _NewEditSchedState extends State<NewEditSched> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  TextEditingController _notesTextController;
  RoundedLoadingButtonController _btnController;
  TextEditingController _missionnameTextController;
  PageController _pageController = PageController();
  // final _formsPageViewController = PageController();
  List _forms;

  TextEditingController _vehiclekindTextController;
  TextEditingController _vehicleplateTextController;
  TextEditingController _vehiclebrandTextController;
  TextEditingController _vehiclemodelTextController;
  TextEditingController _vehicledescTextController;
  TextEditingController _mapTextConroller;
  FirebaseAuth auth = FirebaseAuth.instance;
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

  List<String> userSearchItemsx = [];
  List<String> userSearchItemsName = [];
  List<String> userSearchArrestx = [];
  List<String> userSearchArrestName = [];
  List<String> userSearchSecurityx = [];
  List<String> userSearchSecurityName = [];
  List<String> userSearchBlockx = [];
  List<String> userSearchBlockName = [];

  List<String> deluserSearchItemsx = [];
  List<String> deluserSearchItemsName = [];
  List<String> deluserSearchArrestx = [];
  List<String> deluserSearchArrestName = [];
  List<String> deluserSearchSecurityx = [];
  List<String> deluserSearchSecurityName = [];
  List<String> deluserSearchBlockx = [];
  List<String> deluserSearchBlockName = [];

  List<String> userFinalItemsArrestForSecurity = [];
  List<String> userFinalItemsArrestSecurityForBlock = [];
  List<String> userLeader = [];
  List<String> _checked = []; //["A", "B"];
  List<String> userAll = [];
  List<String> userCheck = [];
  DateTime finalDatex;
  bool listSelec = false;
  String finalDate = Schedule.date;
  String startTime;
  String endTime; // = Schedule.endtime
  String docTitle;
  String oldcollectionid;
  bool checknull1 = false;
  bool checknull2 = false;
  bool isMenuOpen = false;
  var uuid = Uuid();
  bool _blackVisible = false;
  bool _isEdited = false;
  String missionname;

  List<String> vehiclelist = [];
  List<String> discardedvehicle = [];

  String dropdownValue;
  String dropdownValuex;

  String dropdownValuey;
  double lattap = 0;
  double lngtap = 0;
  double lngtapnew = 0;
  double lattapnew = 0;

  List<String> allowedSpotter = [];
  List<String> allowedLeader = [];
  List<String> allowedSpokesperson = [];
  List<String> allowedPatrol = [];
  bool _stempty = false;
  bool _etempty = false;
  List<String> memuid = [];
  List<String> withadmin = [];

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    _isEdited = false;
    _notesTextController = TextEditingController();
    _notesTextController.text = Schedule.notes;
    _btnController = RoundedLoadingButtonController();
    _missionnameTextController = TextEditingController();
    _vehicledescTextController = TextEditingController();
    _vehiclemodelTextController = TextEditingController();
    _vehiclebrandTextController = TextEditingController();
    _vehicleplateTextController = TextEditingController();
    _vehiclekindTextController = TextEditingController();
    _mapTextConroller = TextEditingController();
    userSearchItemsx = Schedule.investteam;
    userSearchItemsName = Schedule.investteamname;
    userSearchArrestx = Schedule.searchteam;
    userSearchArrestName = Schedule.searchteamname;
    userSearchSecurityx = Schedule.secuteam;
    userSearchSecurityName = Schedule.secuteamname;
    userSearchBlockx = Schedule.blockteam;
    userSearchBlockName = Schedule.blockteamname;
    lattap = Schedule.latloc;
    lngtap = Schedule.lngloc;
    _mapTextConroller.text = Schedule.location;
    _missionnameTextController.text = Schedule.missionname;
    userAll = Schedule.blockteam + Schedule.secuteam + Schedule.searchteam + Schedule.investteam;
    vehiclelist.addAll(Schedule.vehicle);
    oldcollectionid = Schedule.collectionid;
    print(Schedule.blockteam.toString());
    print(Schedule.searchteam.length);

    print("searchSUB");

    super.initState();
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page.toInt() + 1, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page.toInt() - 1, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
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
Are you sure to edit this schedule for: $fffDate?
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
    User user = auth.currentUser;
    String notes = _notesTextController.text;
    var outputFormat2 = DateFormat('MM-dd-yyyy hh:mm a');
    var finalCreate = outputFormat2.format(DateTime.now());
    var location = _mapTextConroller.text;
    var outputFormat2x = DateFormat('MM-dd-yyyy hh:mm a');
    var finalCreatex = outputFormat2x.format(DateTime.now());
    missionname = _missionnameTextController.text;
    List<String> toadd = [];
    var collectionid2 = uuid.v1();
    List<String> dummylang = [];
    var usercheck;

    var activity = 'Edited a schedule with mission name: $missionname';
    var currentUser = user.uid;

    var b = DateFormat('MM-dd-yyyy HH:mm').parse(startTime.toString());
    Timestamp a = Timestamp.fromDate(b);

    var c = DateFormat('MM-dd-yyyy HH:mm').parse(endTime.toString());
    Timestamp d = Timestamp.fromDate(c);

    if (lattapnew == 0 || lngtapnew == 0) {
      lattapnew = Schedule.latloc;
      lngtapnew = Schedule.lngloc;
    }

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
            'addedby': 'toadd',
            'status': '',
            'foundby': FieldValue.arrayUnion(dummylang),
            'foundbyuid': '',
            'foundtime': Timestamp.now(),
            'foundonmission': '',
            'addedtime': Timestamp.now(),
          }).then((value) async {
            // FirebaseFirestore.instance.collection("trialvehicles").doc(vehiclelist[i]).delete().then((value) {
            //   print('deleted');
            //   print(vehiclelist);
            // });
            QuerySnapshot discarded = await FirebaseFirestore.instance.collection('vehicles').where('vehicle', isEqualTo: discardedvehicle[i]).get();
            discarded.docs.forEach((element) {
              // FirebaseFirestore.instance.collection('vehicles').doc(element.data()['vehicle'].delete();
              FirebaseFirestore.instance.collection("vehicles").doc(element.data()['vehicle']).delete();
            });
          });
        });
      }

      if (Schedule.teamlead.toString() != dropdownValue.toString()) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: Schedule.teamlead.toString()).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      if (Schedule.spotter.toString() != dropdownValue.toString()) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: Schedule.spotter.toString()).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      if (Schedule.spokesperson.toString() != dropdownValue.toString()) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: Schedule.spokesperson.toString()).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      for (var i = 0; i < deluserSearchItemsx.length; i++) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: deluserSearchItemsx[i]).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      for (var i = 0; i < deluserSearchArrestx.length; i++) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: deluserSearchArrestx[i]).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      for (var i = 0; i < deluserSearchSecurityx.length; i++) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: deluserSearchSecurityx[i]).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      for (var i = 0; i < deluserSearchBlockx.length; i++) {
        QuerySnapshot delete = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: deluserSearchBlockx[i]).get();
        delete.docs.forEach((doc) {
          FirebaseFirestore.instance.collection('users').doc(doc.data()['collectionId']).collection('schedule').doc(oldcollectionid.toString()).delete();
        });
      }

      for (var i = 0; i < userSearchBlockx.length; i++) {
        QuerySnapshot search = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: userSearchBlockx[i]).get();
        search.docs.forEach((document) {
          memuid.add(document.data()['collectionId']);
          FirebaseFirestore.instance
              .collection('users')
              .doc(document.data()['collectionId'])
              .collection('schedule')
              .doc(oldcollectionid.toString())
              .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'blockteam'});
        });
      }

      for (var i = 0; i < userSearchItemsx.length; i++) {
        QuerySnapshot search = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: userSearchItemsx[i]).get();
        search.docs.forEach((document) {
          memuid.add(document.data()['collectionId']);
          FirebaseFirestore.instance
              .collection('users')
              .doc(document.data()['collectionId'])
              .collection('schedule')
              .doc(oldcollectionid.toString())
              .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'investteam'});
        });
      }

      for (var i = 0; i < userSearchArrestx.length; i++) {
        QuerySnapshot search = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: userSearchArrestx[i]).get();
        search.docs.forEach((document) {
          memuid.add(document.data()['collectionId']);
          FirebaseFirestore.instance
              .collection('users')
              .doc(document.data()['collectionId'])
              .collection('schedule')
              .doc(oldcollectionid.toString())
              .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'searchteam'});
        });
      }

      for (var i = 0; i < userSearchSecurityx.length; i++) {
        QuerySnapshot search = await FirebaseFirestore.instance.collection('users').where('badgeNum', isEqualTo: userSearchSecurityx[i]).get();
        search.docs.forEach((document) {
          memuid.add(document.data()['collectionId']);
          FirebaseFirestore.instance
              .collection('users')
              .doc(document.data()['collectionId'])
              .collection('schedule')
              .doc(oldcollectionid.toString())
              .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'secuteam'});
        });
      }

      QuerySnapshot search = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: dropdownValue.toString()).get();
      search.docs.forEach((document) {
        memuid.add(document.data()['collectionId']);
        FirebaseFirestore.instance
            .collection('users')
            .doc(document.data()['collectionId'])
            .collection('schedule')
            .doc(oldcollectionid.toString())
            .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'teamlead'});
      });

      QuerySnapshot searchx = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: dropdownValuex.toString()).get();
      searchx.docs.forEach((document) {
        memuid.add(document.data()['collectionId']);
        FirebaseFirestore.instance
            .collection('users')
            .doc(document.data()['collectionId'])
            .collection('schedule')
            .doc(oldcollectionid.toString())
            .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'spotter'});
      });

      QuerySnapshot searchy = await FirebaseFirestore.instance.collection('users').where('fullName', isEqualTo: dropdownValuey.toString()).get();
      searchy.docs.forEach((document) {
        memuid.add(document.data()['collectionId']);
        FirebaseFirestore.instance
            .collection('users')
            .doc(document.data()['collectionId'])
            .collection('schedule')
            .doc(oldcollectionid.toString())
            .set({'scheduleuid': oldcollectionid.toString(), 'endtime': endTime.toString(), 'starttime': startTime.toString(), "querystarttime": a, "queryendtime": d, "uid": document.data()['collectionId'], "position": 'spokesperson'});
      });

      QuerySnapshot snapx = await FirebaseFirestore.instance.collection('trialvehicles').get();
      snapx.docs.forEach((documentx) {
        FirebaseFirestore.instance.collection("trialvehicles").doc(documentx.data()['plate']).delete();
      });

      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
      username.docs.forEach((document) {
        usercheck = document.data()['fullName'];
        toadd.add(document.data()['fullName']);
      });

      withadmin = withadmin + memuid;
      withadmin.add(user.uid.toString());

      FirebaseFirestore.instance.collection("chat_schedule").doc(oldcollectionid.toString()).update({
        'memberuid': FieldValue.arrayUnion(withadmin),
        'missionname': missionname,
        'endtime': endTime.toString(),
        'starttime': startTime.toString(),
        // 'collectionid': oldcollectionid.toString(),
        'recentmessage': 'Edited the schedule information.',
        'recentmessagesender': 'Admin',
        'recentmessagetime': Timestamp.now(),
      });

      FirebaseFirestore.instance.collection("schedule").doc(oldcollectionid.toString()).update({
        //  'likedby': FieldValue.arrayUnion(hello),
        "teamlead": Schedule.teamlead,
        "spotter": Schedule.spotter,
        "spokesperson": Schedule.spokesperson,
        // "date": finalDate.toString(),
        "starttime": Schedule.starttime,
        "endtime": Schedule.endtime,
        "location": Schedule.location,
        "kind": Schedule.kind,
        "datecreated": Schedule.datecreated,
        "createdby": Schedule.createdby,
        "status": Schedule.status,
        "notes": Schedule.notes,
        "missionname": Schedule.missionname,
        "collectionid": Schedule.collectionid,
        "blockteamname": FieldValue.arrayRemove(deluserSearchBlockName),
        "investteamname": FieldValue.arrayRemove(deluserSearchItemsName),
        "searchteamname": FieldValue.arrayRemove(deluserSearchArrestName),
        "secuteamname": FieldValue.arrayRemove(deluserSearchSecurityName),
        "blockteam": FieldValue.arrayRemove(deluserSearchBlockx),
        "investteam": FieldValue.arrayRemove(deluserSearchItemsx),
        "searchteam": FieldValue.arrayRemove(deluserSearchArrestx),
        "secuteam": FieldValue.arrayRemove(deluserSearchSecurityx),
        "memberuid": FieldValue.arrayRemove(Schedule.memberuid),
        "vehicle": vehiclelist,
        'flaggedvehicles': '',
        'lastflag': '',
        'scannedvehicles': '',
        'lastscan': '',
        'voilast': '',
        'vointerest': '',
      }).then((value) {
        FirebaseFirestore.instance.collection("schedule").doc(oldcollectionid.toString()).update({
          //  'likedby': FieldValue.arrayUnion(hello),
          "teamlead": dropdownValue.toString(),
          "spotter": dropdownValuex.toString(),
          "spokesperson": dropdownValuey.toString(),
          // "date": finalDate.toString(),
          "starttime": startTime.toString(),
          "endtime": endTime.toString(),
          "kind": _checked.toString(),
          "datecreated": Schedule.datecreated,
          "createdby": Schedule.createdby,
          "status": "toadd",
          "notes": notes,
          "location": location,
          "loclat": lattapnew,
          "loclng": lngtapnew,
          "missionname": missionname,
          "collectionid": Schedule.collectionid,
          "blockteamname": FieldValue.arrayUnion(userSearchBlockName),
          "investteamname": FieldValue.arrayUnion(userSearchItemsName),
          "searchteamname": FieldValue.arrayUnion(userSearchArrestName),
          "secuteamname": FieldValue.arrayUnion(userSearchSecurityName),
          "blockteam": FieldValue.arrayUnion(userSearchBlockx),
          "investteam": FieldValue.arrayUnion(userSearchItemsx),
          "searchteam": FieldValue.arrayUnion(userSearchArrestx),
          "secuteam": FieldValue.arrayUnion(userSearchSecurityx),
          "editedby": FieldValue.arrayUnion(toadd),
          "memberuid": FieldValue.arrayUnion(memuid),
          "editedtime": finalCreatex,
          "vehicle": vehiclelist,
          "querystarttime": a,
          "queryendtime": d,
          'flaggedvehicles': '',
          'lastflag': '',
          'scannedvehicles': '',
          'lastscan': '',
          'voilast': '',
          'vointerest': '',
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
            'editcreate_collectionid': oldcollectionid,
          });
        });
        print("done set to new docs");
        // Navigator.pop(context);
        try {
          print("this is the length");

          _showSuccessAlert(
              title: "Congrats!",
              content: "Successfully Edited!", //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          Timer(Duration(seconds: 3), () {
            setState(() {
              _isEdited = true;
              _btnController.reset();
              Get.snackbar(
                "Success!",
                "New Edited Schedule Added.",
                duration: Duration(seconds: 3),
              );
            });
            Get.offAll(Fourth());
          });
        } catch (e) {
          _showErrorAlert(
              title: "SCHEDULE FAILED",
              content: e.printError(), //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
        }

        // Get.back();
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
    double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 12;
    return size;
  }

  getFuture() async {
    QuerySnapshot getallLeader = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Leader').get();
    getallLeader.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        var y = DateFormat('MM-dd-yyyy HH:mm').parse(endTime);

        if (g == (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) || y == (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('same date same time');
          allowedLeader.add(document.data()['fullName']);
        } else {
          if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
            print('nasa gitna ang starttime');
            allowedLeader.add(document.data()['fullName']);
          } else {
            if (y.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && y.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
              print('nasa gitna ang endtime');
              allowedLeader.add(document.data()['fullName']);
            } else {
              if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isBefore(y)) {
                allowedLeader.add(document.data()['fullName']);
              } else {
                if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isBefore(y)) {
                  allowedLeader.add(document.data()['fullName']);
                } else {
                  print('do nothing');
                }
              }
            }
          }
        }
        // if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
        //   print('yes');
        // } else {
        //   setState(() {});
        //   print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
        //   allowedLeader.add(document.data()['fullName']);
        //   // allowedLeader.add(Schedule.teamlead);
        // }
      });
    });

    QuerySnapshot getallSpotter = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Spotter').get();
    getallSpotter.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        var y = DateFormat('MM-dd-yyyy HH:mm').parse(endTime);

        if (g == (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) || y == (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('same date same time');
          allowedSpotter.add(document.data()['fullName']);
        } else {
          if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
            print('nasa gitna ang starttime');
            allowedSpotter.add(document.data()['fullName']);
          } else {
            if (y.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && y.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
              print('nasa gitna ang endtime');
              allowedSpotter.add(document.data()['fullName']);
            } else {
              if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isBefore(y)) {
                allowedSpotter.add(document.data()['fullName']);
              } else {
                if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isBefore(y)) {
                  allowedSpotter.add(document.data()['fullName']);
                } else {
                  print('do nothing');
                }
              }
            }
          }
        }
        // if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
        //   print('yes');
        // } else {
        //   setState(() {});
        //   print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
        //   allowedSpotter.add(document.data()['fullName']);
        //   // allowedSpotter.add(Schedule.spotter);
        // }
      });
    });

    QuerySnapshot getallSpokesperson = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Spokesperson').get();
    getallSpokesperson.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        var y = DateFormat('MM-dd-yyyy HH:mm').parse(endTime);

        if (g == (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) || y == (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('same date same time');
          allowedSpokesperson.add(document.data()['fullName']);
        } else {
          if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
            print('nasa gitna ang starttime');
            allowedSpokesperson.add(document.data()['fullName']);
          } else {
            if (y.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && y.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
              print('nasa gitna ang endtime');
              allowedSpokesperson.add(document.data()['fullName']);
            } else {
              if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isBefore(y)) {
                allowedSpokesperson.add(document.data()['fullName']);
              } else {
                if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isBefore(y)) {
                  allowedSpokesperson.add(document.data()['fullName']);
                } else {
                  print('do nothing');
                }
              }
            }
          }
        }
        // if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
        //   print('yes');
        // } else {
        //   setState(() {});
        //   print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
        //   allowedSpokesperson.add(document.data()['fullName']);
        //   // allowedSpokesperson.add(Schedule.spokesperson);
        // }
      });
    });

    QuerySnapshot getallPatrol = await FirebaseFirestore.instance.collection('users').where('position', isEqualTo: 'Patrolman').get();
    getallPatrol.docs.forEach((document) async {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').doc(document.data()['collectionId']).collection('schedule').get();
      username.docs.forEach((documentx) {
        var g = DateFormat('MM-dd-yyyy HH:mm').parse(startTime);
        var y = DateFormat('MM-dd-yyyy HH:mm').parse(endTime);

        if (g.isAtSameMomentAs(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) || y.isAtSameMomentAs(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
          print('same date same time');
          allowedPatrol.add(document.data()['fullName']);
        } else {
          if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
            print('nasa gitna ang starttime');
            allowedPatrol.add(document.data()['fullName']);
          } else {
            if (y.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && y.isBefore(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
              print('nasa gitna ang endtime');
              allowedPatrol.add(document.data()['fullName']);
            } else {
              if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime']).isBefore(y)) {
                allowedPatrol.add(document.data()['fullName']);
              } else {
                if (DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isAfter(g) && DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']).isBefore(y)) {
                  allowedPatrol.add(document.data()['fullName']);
                } else {
                  print('do nothing');
                }
              }
            }
          }
        }
        // if (g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['starttime'])) && g.isAfter(DateFormat('MM-dd-yyyy HH:mm').parse(documentx.data()['endtime']))) {
        //   print('yes');
        // } else {
        //   setState(() {});
        //   print('no'); //means pwede silang ilagay sa listahan ng hindi pwede i show
        //   allowedPatrol.add(document.data()['fullName']);
        // }
      });
    });
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
                    padding: const EdgeInsets.all(18.0),
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
                      ],
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 65,
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
                    padding: const EdgeInsets.only(
                      top: 75.0,
                    ),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: Get.height,
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
                                    // userFinalItemsArrestSecurityForBlock = userFinalItemsArrestForSecurity + userSearchSecurityName;
                                    final List<DocumentSnapshot> userList = snapshotx.data.docs.where((DocumentSnapshot documentSnapshot) {
                                      return !userAll.contains(documentSnapshot['badgeNum']);
                                    }).toList();

                                    final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                      return !allowedPatrol.contains(documentSnapshot['fullName']);
                                    }).toList();
                                    // final int cardLength = userList.length;
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userPatrol.length,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card =
                                          //     userList[index];
                                          return Dismissible(
                                            key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                      userSearchBlockName.add(userPatrol[index]['fullName']);
                                                      userSearchBlockx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchBlockName.add(userPatrol[index]['fullName']);
                                                      userSearchBlockx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
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
                                                          backgroundImage: NetworkImage(userPatrol[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userPatrol[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userPatrol[index]["fullName"].toString(),
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
                    padding: const EdgeInsets.all(18.0),
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
                      ],
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 65,
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
                    padding: const EdgeInsets.only(
                      top: 75.0,
                    ),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: Get.height,
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
                                    // userFinalItemsArrestForSecurity = userSearchItemsName + userSearchArrestName;
                                    final List<DocumentSnapshot> userList = snapshotx.data.docs.where((DocumentSnapshot documentSnapshot) {
                                      return !userAll.contains(documentSnapshot['badgeNum']);
                                    }).toList();

                                    final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                      return !allowedPatrol.contains(documentSnapshot['fullName']);
                                    }).toList();
                                    // final int cardLength = userList.length;
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userPatrol.length,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card =
                                          //     userList[index];
                                          return Dismissible(
                                            key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                      userSearchSecurityName.add(userPatrol[index]['fullName']);
                                                      userSearchSecurityx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchSecurityName.add(userPatrol[index]['fullName']);
                                                      userSearchSecurityx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
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
                                                          backgroundImage: NetworkImage(userPatrol[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userPatrol[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userPatrol[index]["fullName"].toString(),
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
                    padding: const EdgeInsets.all(18.0),
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
                      ],
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 65,
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
                    padding: const EdgeInsets.only(
                      top: 75.0,
                    ),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: Get.height,
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
                                      return !userAll.contains(documentSnapshot['badgeNum']);
                                    }).toList();

                                    final List<DocumentSnapshot> userPatrol = userListx.where((DocumentSnapshot documentSnapshot) {
                                      return !allowedPatrol.contains(documentSnapshot['fullName']);
                                    }).toList();
                                    final int cardLength = userPatrol.length;
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: cardLength,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card =
                                          //     userList[index];
                                          return Dismissible(
                                            key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                      userSearchArrestName.add(userPatrol[index]['fullName']);
                                                      userSearchArrestx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchArrestName.add(userPatrol[index]['fullName']);
                                                      userSearchArrestx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
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
                                                          backgroundImage: NetworkImage(userPatrol[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userPatrol[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userPatrol[index]["fullName"].toString(),
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
                    padding: const EdgeInsets.all(18.0),
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
                      ],
                    ),
                  ),
                  Positioned(
                    right: 50,
                    top: 65,
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
                    padding: const EdgeInsets.only(
                      top: 75.0,
                    ),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                          child: Container(
                            height: Get.height,
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

                                    final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                      return !allowedPatrol.contains(documentSnapshot['fullName']);
                                    }).toList();
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userPatrol.length,
                                        itemBuilder: (_, index) {
                                          // final DocumentSnapshot _card = snapshot.data.docs[index];
                                          return Dismissible(
                                            key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                      userSearchItemsName.add(userPatrol[index]['fullName']);
                                                      userSearchItemsx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
                                                    },
                                                  );
                                                });
                                              } else {
                                                mystate(() {
                                                  setState(
                                                    () {
                                                      userSearchItemsName.add(userPatrol[index]['fullName']);
                                                      userSearchItemsx.add(userPatrol[index]['badgeNum']);
                                                      userAll.add(userPatrol[index]['badgeNum']);
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
                                                          backgroundImage: NetworkImage(userPatrol[index]["picUrl"].toString()),
                                                        ),
                                                      ),
                                                      title: Text(userPatrol[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userPatrol[index]["fullName"].toString(),
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

  _buildMainTeam() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
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
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 50, bottom: 10.0, left: 20),
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
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text("Team Leader"),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                                                    child: Text("  Old Team Leader:" + '  ' + Schedule.teamlead.toString(), style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              ),
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
                                                  color: Color(0xff085078),
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
                                    padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text("Spotter"),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                                                    child: Text("  Old Spotter:" + '  ' + Schedule.spotter.toString(), style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              ),
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
                                                  color: Color(0xff085078),
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
                                    padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 300,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text("Spokesperson"),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                                                    child: Text("  Old Spokesperson:" + '  ' + Schedule.spokesperson.toString(), style: TextStyle(color: Colors.red)),
                                                  ),
                                                ],
                                              ),
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
                                                  color: Color(0xff085078),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 50.0,
                                            spreadRadius: 15.0,
                                            offset: Offset(
                                              0.0,
                                              0.0,
                                            ),
                                          )
                                        ],
                                      ),
                                      height: 30,
                                      width: 40,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 40,
                                            child: RaisedButton(
                                              onPressed: () {
                                                previousPage();
                                              },
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                              padding: const EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                                ),
                                                child: Container(
                                                  constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            width: 40,
                                            child: RaisedButton(
                                              onPressed: () {
                                                nextPage();
                                              },
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                              padding: const EdgeInsets.all(0.0),
                                              child: Ink(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                                ),
                                                child: Container(
                                                  constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                                  alignment: Alignment.center,
                                                  child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
                                                ),
                                              ),
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
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildMainTime() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 0.0, left: 30),
                          child: Text(
                            "Deployment Time",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 40.0, left: 40),
                          child: Text(
                            "*Officer availability depends on the deployment time.",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //here ang contents

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  "Start Time",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: new BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 50.0,
                                      spreadRadius: 15.0,
                                      offset: Offset(
                                        0.0,
                                        0.0,
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
                                          DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
                                            print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                                          }, onConfirm: (date) {
                                            var outputFormat2 = DateFormat('MM-dd-yyyy HH:mm a');
                                            var outputDate2 = outputFormat2.format(date);
                                            setState(() {
                                              checknull1 = true;
                                            });
                                            setState(() {
                                              startTime = outputDate2;
                                              allowedSpotter = [];
                                              allowedLeader = [];
                                              allowedSpokesperson = [];
                                              _stempty = true;
                                              if (endTime.isBlank) {
                                                print('hello');
                                              } else {
                                                if (startTime.compareTo(endTime) > 0) {
                                                  print("hindi ito pwede");
                                                  endTime = "";
                                                  _showErrorAlert(title: "Time Failed", content: "Start time should be before Start time!", onPressed: _changeBlackVisible, context: context);
                                                }
                                              }

                                              print('confirm $date');
                                            });
                                            getFuture();
                                          }, currentTime: DateTime.now());
                                        },
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                        padding: const EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                          ),
                                          child: Container(
                                            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Container(
                            height: 30,
                            width: 480,
                            color: Colors.white,
                            child: Center(
                              child: checknull1
                                  ? Text(
                                      startTime.toString(),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0, top: 8),
                              child: Text("  Old Start Time:" + '  ' + Schedule.starttime.toString(), style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 28.0),
                                child: Text(
                                  "End Time",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20.0,
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0, left: 0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 50.0,
                                        spreadRadius: 15.0,
                                        offset: Offset(
                                          0.0,
                                          0.0,
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
                                            DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onChanged: (date) {
                                              print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                                            }, onConfirm: (date) {
                                              var outputFormat2 = DateFormat('MM-dd-yyyy HH:mm a');
                                              var outputDate2 = outputFormat2.format(date);
                                              setState(() {
                                                checknull2 = true;
                                              });
                                              if (startTime.isEmpty) {
                                                _showErrorAlert(title: "Time Failed", content: "Start time shoud not be empty!", onPressed: _changeBlackVisible, context: context);
                                              } else {
                                                setState(() {
                                                  _etempty = true;
                                                  endTime = outputDate2;
                                                  allowedSpotter = [];
                                                  allowedLeader = [];
                                                  allowedSpokesperson = [];

                                                  if (endTime.compareTo(startTime) < 0) {
                                                    print("hindi ito pwede");
                                                    endTime = "";
                                                    _showErrorAlert(title: "Time Failed", content: "End time should be after Start time!", onPressed: _changeBlackVisible, context: context);
                                                  }
                                                  if (endTime == startTime) {
                                                    endTime = "";
                                                    _showErrorAlert(title: "Time Failed", content: "End time is the same as Start time!", onPressed: _changeBlackVisible, context: context);
                                                    print('equal');
                                                  }

                                                  print('confirm $date');
                                                });
                                                getFuture();
                                              }
                                            }, currentTime: DateTime.now());
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                          padding: const EdgeInsets.all(0.0),
                                          child: Ink(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                            ),
                                            child: Container(
                                              constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.add, size: 20, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Container(
                            height: 30,
                            width: 480,
                            color: Colors.white,
                            child: Center(
                              child: checknull2
                                  ? Text(
                                      endTime.toString(),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0, top: 8),
                              child: Text("  Old End Time:" + '  ' + Schedule.endtime.toString(), style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 40),
                          child: Container(
                            decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 50.0,
                                  spreadRadius: 15.0,
                                  offset: Offset(
                                    0.0,
                                    0.0,
                                  ),
                                )
                              ],
                            ),
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildNotesKindMission() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents
                          Container(
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
                                            padding: const EdgeInsets.only(top: 50.0, left: 20, right: 0, bottom: 0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Purpose of Deployment",
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
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Text(
                                  "Type of Mission",
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
                                padding: const EdgeInsets.only(left: 35.0, top: 8),
                                child: Text("  Old type of mission:" + '  ' + Schedule.kind.toString(), style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: CheckboxGroup(
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
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0, top: 20),
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
                            padding: const EdgeInsets.only(top: 8.0, right: 28, left: 28, bottom: 25),
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
                                    color: Color(0xff085078),
                                    icon: Icon(Icons.turned_in),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'Mission Name',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildInvestTeam() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents

                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Row(
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
                                // _isButx1 ? _buildInvestSub() : Container(),
                                Padding(
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
                                                gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 315,
                            // width: 480,
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
                                      return userSearchItemsx.contains(documentSnapshot['badgeNum']);
                                    }).toList();
                                    final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                      return !allowedPatrol.contains(documentSnapshot['fullName']);
                                    }).toList();

                                    return Container(
                                      child: ListView.builder(
                                        itemCount: userPatrol.length,
                                        itemBuilder: (_, index) {
                                          return Dismissible(
                                            key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                    userSearchItemsName.remove(userPatrol[index]['fullName']);
                                                    userSearchItemsx.remove(userPatrol[index]['badgeNum']);
                                                    userAll.remove(userPatrol[index]['badgeNum']);
                                                    deluserSearchItemsName.add(userPatrol[index]['fullName']);
                                                    deluserSearchItemsx.add(userPatrol[index]['badgeNum']);
                                                  },
                                                );
                                              } else {
                                                setState(
                                                  () {
                                                    userSearchItemsName.remove(userPatrol[index]['fullName']);
                                                    userSearchItemsx.remove(userPatrol[index]['badgeNum']);
                                                    userAll.remove(userPatrol[index]['badgeNum']);
                                                    deluserSearchItemsName.add(userPatrol[index]['fullName']);
                                                    deluserSearchItemsx.add(userPatrol[index]['badgeNum']);
                                                  },
                                                );
                                              }
                                              setState(() {});
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
                                                          backgroundImage: NetworkImage(userPatrol[index]["picUrl"]),
                                                        ),
                                                      ),
                                                      title: Text(userPatrol[index]["badgeNum"]),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 0.0),
                                                              child: Text(
                                                                userPatrol[index]["fullName"].toString(),
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

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSearchArrestTeam() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents
                          Container(
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
                                            padding: const EdgeInsets.only(top: 50.0, left: 5, bottom: 50),
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
                                                    // _isButx2 ? _buildSearchSub() : Container(),
                                                    Padding(
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
                                                                    gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                                                    )
                                                  ],
                                                ),
                                                // _secondShow ? _showSearchList() : Container(),
                                                Container(
                                                  height: 265,
                                                  // width: 480,
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
                                                            return userSearchArrestx.contains(documentSnapshot['badgeNum']);
                                                          }).toList();
                                                          final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                                            return !allowedPatrol.contains(documentSnapshot['fullName']);
                                                          }).toList();

                                                          return Container(
                                                            child: ListView.builder(
                                                              itemCount: userPatrol.length,
                                                              itemBuilder: (_, index) {
                                                                return Dismissible(
                                                                  key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                                          userSearchArrestName.remove(userPatrol[index]['fullName']);
                                                                          userSearchArrestx.remove(userPatrol[index]['badgeNum']);
                                                                          userAll.remove(userPatrol[index]['badgeNum']);
                                                                          deluserSearchArrestName.add(userPatrol[index]['fullName']);
                                                                          deluserSearchArrestx.add(userPatrol[index]['badgeNum']);
                                                                        },
                                                                      );
                                                                    } else {
                                                                      setState(
                                                                        () {
                                                                          userSearchArrestName.remove(userPatrol[index]['fullName']);
                                                                          userSearchArrestx.remove(userPatrol[index]['badgeNum']);
                                                                          userAll.remove(userPatrol[index]['badgeNum']);
                                                                          deluserSearchArrestName.add(userPatrol[index]['fullName']);
                                                                          deluserSearchArrestx.add(userPatrol[index]['badgeNum']);
                                                                        },
                                                                      );
                                                                    }
                                                                    setState(() {});
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
                                                                                backgroundImage: NetworkImage(userPatrol[index]["picUrl"]),
                                                                              ),
                                                                            ),
                                                                            title: Text(userPatrol[index]["badgeNum"]),
                                                                            subtitle: Row(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(left: 0.0),
                                                                                    child: Text(
                                                                                      userPatrol[index]["fullName"].toString(),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSecurityTeam() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents
                          Container(
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
                                            padding: const EdgeInsets.only(top: 50.0, right: 0, left: 5, bottom: 50),
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
                                                    // _isButx3 ? _buildSecuritySub() : Container(),
                                                    Padding(
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
                                                                    gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                                                    )
                                                  ],
                                                ),
                                                // _thirdShow ? _showSecurityList() : Container(),
                                                Container(
                                                  height: 265,
                                                  // width: 480,
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
                                                            return userSearchSecurityx.contains(documentSnapshot['badgeNum']);
                                                          }).toList();
                                                          final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                                            return !allowedPatrol.contains(documentSnapshot['fullName']);
                                                          }).toList();

                                                          return Container(
                                                            child: ListView.builder(
                                                              itemCount: userPatrol.length,
                                                              itemBuilder: (_, index) {
                                                                return Dismissible(
                                                                  key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                                          userSearchSecurityName.remove(userPatrol[index]['fullName']);
                                                                          userSearchSecurityx.remove(userPatrol[index]['badgeNum']);
                                                                          userAll.remove(userPatrol[index]['badgeNum']);
                                                                          deluserSearchSecurityName.add(userPatrol[index]['fullName']);
                                                                          deluserSearchSecurityx.add(userPatrol[index]['badgeNum']);
                                                                        },
                                                                      );
                                                                    } else {
                                                                      setState(
                                                                        () {
                                                                          userSearchSecurityName.remove(userPatrol[index]['fullName']);
                                                                          userSearchSecurityx.remove(userPatrol[index]['badgeNum']);
                                                                          userAll.remove(userPatrol[index]['badgeNum']);
                                                                          deluserSearchSecurityName.add(userPatrol[index]['fullName']);
                                                                          deluserSearchSecurityx.add(userPatrol[index]['badgeNum']);
                                                                        },
                                                                      );
                                                                    }
                                                                    setState(() {});
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
                                                                                backgroundImage: NetworkImage(userPatrol[index]["picUrl"]),
                                                                              ),
                                                                              // child: Text("hellox"),
                                                                            ),
                                                                            title: Text(userPatrol[index]["badgeNum"]),
                                                                            subtitle: Row(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(left: 0.0),
                                                                                    child: Text(
                                                                                      userPatrol[index]["fullName"].toString(),
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
                                                )
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBlockTeam() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents
                          Container(
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
                                            padding: const EdgeInsets.only(top: 50.0, left: 5, bottom: 50),
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
                                                    // _isButx4 ? _buildBlockSub() : Container(),
                                                    Padding(
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
                                                                    gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                                                    ),
                                                  ],
                                                ),
                                                // _fourthShow ? _showBlockList() : Container(),
                                                Container(
                                                  height: 265,
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
                                                            return userSearchBlockx.contains(documentSnapshot['badgeNum']);
                                                          }).toList();
                                                          final List<DocumentSnapshot> userPatrol = userList.where((DocumentSnapshot documentSnapshot) {
                                                            return !allowedPatrol.contains(documentSnapshot['fullName']);
                                                          }).toList();

                                                          return Container(
                                                            child: ListView.builder(
                                                              itemCount: userPatrol.length,
                                                              itemBuilder: (_, index) {
                                                                return Dismissible(
                                                                  key: Key('item ${userPatrol[index]["badgeNum"]}'),
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
                                                                          userSearchBlockName.remove(userPatrol[index]['fullName']);
                                                                          userSearchBlockx.remove(userPatrol[index]['badgeNum']);
                                                                          userAll.remove(userPatrol[index]['badgeNum']);
                                                                          deluserSearchBlockName.add(userPatrol[index]['fullName']);
                                                                          deluserSearchBlockx.add(userPatrol[index]['badgeNum']);
                                                                        },
                                                                      );
                                                                    } else {
                                                                      setState(
                                                                        () {
                                                                          userSearchBlockName.remove(userPatrol[index]['fullName']);
                                                                          userSearchBlockx.remove(userPatrol[index]['badgeNum']);
                                                                          userAll.remove(userPatrol[index]['badgeNum']);
                                                                          deluserSearchBlockName.add(userPatrol[index]['fullName']);
                                                                          deluserSearchBlockx.add(userPatrol[index]['badgeNum']);
                                                                        },
                                                                      );
                                                                    }
                                                                    setState(() {});
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
                                                                                backgroundImage: NetworkImage(userPatrol[index]["picUrl"]),
                                                                              ),
                                                                            ),
                                                                            title: Text(userPatrol[index]["badgeNum"]),
                                                                            subtitle: Row(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(left: 0.0),
                                                                                    child: Text(
                                                                                      userPatrol[index]["fullName"].toString(),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildVehicle() {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(10.0),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Stack(children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 20.0),
                              child: Text(
                                "Add Vehicle",
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
                                "Type of Vehicle",
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
                                  color: Color(0xff085078),
                                  icon: Icon(Icons.style),
                                  iconSize: 20.0,
                                  onPressed: () {},
                                ),
                                contentPadding: EdgeInsets.only(left: 25.0),
                                hintText: 'Vehicle Type',
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
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 10,
                            maxLengthEnforced: true,
                            controller: _vehicleplateTextController,
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
                                  color: Color(0xff085078),
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
                                  color: Color(0xff085078),
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
                              height: 150,
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 28.0),
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
                                      String vkind = _vehiclekindTextController.text;
                                      String vplate = _vehicleplateTextController.text;
                                      String vbrand = _vehiclebrandTextController.text;
                                      String vmodel = _vehiclemodelTextController.text;
                                      String vdesc = _vehicledescTextController.text;
                                      String result = _vehicleplateTextController.text.toUpperCase().substring(0, _vehicleplateTextController.text.toUpperCase().indexOf(' '));
                                      print(result);
                                      String s1 = _vehicleplateTextController.text.substring(_vehicleplateTextController.text.indexOf(" ") + 1);
                                      print(s1);

                                      String characters = "[a-zA-Z]";
                                      RegExp regChar = RegExp(characters);
                                      String digits = "[0-9]";
                                      RegExp regDig = RegExp(digits);

                                      if (vkind.isEmpty || vplate.isEmpty || vbrand.isEmpty || vmodel.isEmpty || vdesc.isEmpty) {
                                        _showErrorAlert(
                                            title: "Vehicle adding failed.",
                                            content: 'All fields required!', //show error firebase
                                            onPressed: _changeBlackVisible,
                                            context: context);
                                        _btnController.reset();
                                      } else if (regChar.hasMatch(result)) {
                                        print('ok');
                                        if (result.length < 3) {
                                          print('ok but less than 3');
                                          //pag less than 3 that means mc sya and kailangan dapat ung digit is 5 digits
                                          //check if ung digits is 5
                                          if (regDig.hasMatch(s1)) {
                                            print('ok numbers sya.');
                                            if (s1.length == 5) {
                                              print('ok 5 digits sya');
                                              // setState(() {
                                              // finalVehResult = result + " " + s1;
                                              // checktoDB();
                                              // _toDBfromModal();
                                              // });

                                              FirebaseFirestore.instance.collection("trialvehicles").doc(vplate).set({
                                                'kind': vkind,
                                                'plate': vplate,
                                                'brand': vbrand,
                                                'model': vmodel,
                                                'desc': vdesc,
                                              }).then((value) {
                                                vehiclelist.add(vplate.toUpperCase());
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
                                                // setState(() {
                                                // finalVehResult = result + " " + s1;
                                                // checktoDB();
                                                // _toDBfromModal();
                                                // });

                                                FirebaseFirestore.instance.collection("trialvehicles").doc(vplate).set({
                                                  'kind': vkind,
                                                  'plate': vplate,
                                                  'brand': vbrand,
                                                  'model': vmodel,
                                                  'desc': vdesc,
                                                }).then((value) {
                                                  vehiclelist.add(vplate.toUpperCase());
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

                                                print('this is the final result');
                                                // print(finalVehResult);
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
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                        ),
                        //here ang contents
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildVehicleList() {
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents
                          Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 10.0, left: 50),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 10.0, left: 50),
                            child: Text(
                              "*Swipe left to edit the vehicle.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 40.0, left: 50),
                            child: Text(
                              "*Swipe right to delete the vehicle.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                                  discardedvehicle.add(snapshot.data.docs[index]['plate'].toString());
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
                                                    previousPage();
                                                    _vehiclekindTextController.text = snapshot.data.docs[index]['kind'].toString();
                                                    _vehicleplateTextController.text = snapshot.data.docs[index]['plate'].toString().toUpperCase();
                                                    _vehiclebrandTextController.text = snapshot.data.docs[index]['brand'].toString();
                                                    _vehiclemodelTextController.text = snapshot.data.docs[index]['model'].toString();
                                                    _vehicledescTextController.text = snapshot.data.docs[index]['desc'].toString();
                                                  },
                                                );
                                              }
                                              setState(() {});
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                      // Get.to(LocationMaps());
                                    }, //only after checking
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getLocationText() async {
    // var holdlat = lattapnew.toString();
    // var holdlng = lngtapnew.toString();
    // var doublelat = double.parse(holdlat);
    // var doublelng = double.parse(holdlng);

    var reverseSearchResult = await Nominatim.reverseSearch(
      lat: lattapnew,
      lon: lngtapnew,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );
    print('this is displayname');
    print(reverseSearchResult.displayName);
    _mapTextConroller.text = reverseSearchResult.displayName;
  }

  _showMaps(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      context: context,
      builder: (builder) {
        return SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: false,
          minimum: const EdgeInsets.only(top: 25.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                appBar: AppBar(
                  leading: BackButton(color: Colors.white),
                  title: Text("Details", style: TextStyle(color: Colors.white)),
                  backgroundColor: Color(0xff085078),
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
                    center: latLng.LatLng(lattap, lngtap),
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

  _buildMainLocation() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
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
                                            padding: const EdgeInsets.only(top: 50.0, right: 0, bottom: 50),
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
                                                  padding: const EdgeInsets.only(right: 130.0, top: 10, bottom: 0),
                                                  child: Text(
                                                    "*Tap the + button to show the map.",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10.0,
                                                      fontFamily: 'Nunito-Bold',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 155.0, top: 10, bottom: 20),
                                                  child: Text(
                                                    "*Start and End Time is empty.",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10.0,
                                                      fontFamily: 'Nunito-Bold',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
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
                                                  decoration: new BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.white,
                                                        blurRadius: 50.0,
                                                        spreadRadius: 15.0,
                                                        offset: Offset(
                                                          0.0,
                                                          0.0,
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
                                                          },
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                                          padding: const EdgeInsets.all(0.0),
                                                          child: Ink(
                                                            decoration: const BoxDecoration(
                                                              gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                                            ),
                                                            child: Container(
                                                              constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      previousPage();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  height: 30,
                                  width: 40,
                                  child: RaisedButton(
                                    onPressed: () {
                                      nextPage();
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                                        alignment: Alignment.center,
                                        child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSubmit() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: SafeArea(
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //here ang contents
                          Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 40.0, left: 50),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontFamily: 'Nunito-Bold',
                                fontWeight: FontWeight.bold,
                              ),
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
                                      child: Text('Edit Schedule', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                      controller: _btnController,
                                      onPressed: () {
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
                                            _checked.isEmpty ||
                                            _mapTextConroller.text.isEmpty) {
                                          print("empty");
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          _showErrorAlert(title: "SCHEDULE FAILED", content: "All fields required!", onPressed: _changeBlackVisible, context: context);
                                          _btnController.reset();
                                        } else {
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          showAlertDialog(context);
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                    physics: ClampingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        leading: BackButton(
                            color: Colors.white,
                            onPressed: () async {
                              if (_isEdited == false) {
                                FirebaseFirestore.instance.collection("editedSchedule").doc(Schedule.collectionid).collection("editedSchedule").doc(Schedule.editedtime).delete();

                                QuerySnapshot snapx = await FirebaseFirestore.instance.collection('trialvehicles').get();
                                snapx.docs.forEach((documentx) {
                                  FirebaseFirestore.instance.collection("trialvehicles").doc(documentx.data()['plate']).delete();
                                });

                                Get.offAll(Fourth());
                              } else {
                                Get.offAll(Fourth());
                              }
                            }),
                        // title:
                        // Allows the user to reveal the app bar if they begin scrolling back
                        // up the list of items.
                        brightness: Brightness.light,
                        backgroundColor: Color(0xff085078),
                        floating: true,
                        pinned: true,
                        snap: false,
                        shadowColor: Colors.green,
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
                                      "Edit Schedule",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            background: Image.network(
                              'https://cloudfront-us-east-1.images.arcpublishing.com/cmg/PZQVBPFW2FXTEMMO2EVXFTEXJA.jpg',
                              fit: BoxFit.cover,
                            )),
                        expandedHeight: 200,
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: Get.height,
                          child: PageView(
                            controller: _pageController,
                            children: <Widget>[
                              _buildMainTime(),
                              _buildMainLocation(),
                              _buildNotesKindMission(),
                              _buildMainTeam(),
                              _buildInvestTeam(),
                              _buildSearchArrestTeam(),
                              _buildSecurityTeam(),
                              _buildBlockTeam(),
                              _buildVehicle(),
                              _buildVehicleList(),
                              _buildSubmit(),
                              // Container(
                              //   color: Colors.deepPurple,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //here starts of the animation and navigation bar
                  // AnimatedPositioned(
                  //   duration: Duration(milliseconds: 1500),
                  //   left: isMenuOpen ? 0 : -sidebarSize + 1,
                  //   top: 0,
                  //   curve: Curves.elasticOut,
                  //   child: SizedBox(
                  //     width: sidebarSize,
                  //     child: GestureDetector(
                  //       onPanUpdate: (details) {
                  //         if (details.localPosition.dx <= sidebarSize) {
                  //           setState(() {
                  //             _offset = details.localPosition;
                  //           });
                  //         }

                  //         if (details.localPosition.dx > sidebarSize - 20 && details.delta.distanceSquared > 2) {
                  //           setState(() {
                  //             isMenuOpen = true;
                  //           });
                  //         }
                  //       },
                  //       onPanEnd: (details) {
                  //         setState(() {
                  //           _offset = Offset(0, 0);
                  //         });
                  //       },
                  //       child: Stack(
                  //         children: <Widget>[
                  //           CustomPaint(
                  //             size: Size(sidebarSize, Get.height),
                  //             painter: DrawerPainter(offset: _offset),
                  //           ),
                  //           Container(
                  //             height: Get.height,
                  //             width: sidebarSize,
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               mainAxisSize: MainAxisSize.max,
                  //               children: <Widget>[
                  //                 Container(
                  //                   height: Get.height * 0.30,
                  //                   child: Center(
                  //                     child: Column(
                  //                       children: <Widget>[
                  //                         Container(
                  //                           height: 120,
                  //                           width: 120,
                  //                           // padding: EdgeInsets.all(8.0),
                  //                           child: CircleAvatar(
                  //                             backgroundImage: NetworkImage(UserLog.ppUrl),
                  //                           ),
                  //                         ),
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(top: 28.0),
                  //                           child: Text(
                  //                             UserLog.rank + '. ' + UserLog.fullName.toUpperCase(),
                  //                             style: TextStyle(color: Colors.black45),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Divider(
                  //                   thickness: 1,
                  //                 ),
                  //                 Container(
                  //                   key: globalKey,
                  //                   width: double.infinity,
                  //                   height: menuContainerHeight,
                  //                   child: Column(
                  //                     children: <Widget>[
                  //                       //   MyButton(text: "Schedule Details", iconData: Icons.text_snippet, textSize: getSize(0), height: (menuContainerHeight) / 6, selectedIndex: 0),
                  //                       //   MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 6, selectedIndex: 4),
                  //                       //   MyButton(text: "Add Schedule", iconData: Icons.library_add_check, textSize: getSize(2), height: (menuContainerHeight) / 6, selectedIndex: 1),
                  //                       //   MyButton(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 2),
                  //                       //   MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(4), height: (menuContainerHeight) / 6, selectedIndex: 5),
                  //                       // ],
                  //                       MyButton(text: "Schedule Details", iconData: Icons.text_snippet, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 0),

                  //                       // MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 4),
                  //                       // MyButton(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(2), height: (menuContainerHeight) / 6, selectedIndex: 2),
                  //                       // MyButton(text: "Reset Password of User", iconData: Icons.replay, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 3),
                  //                       MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 5),
                  //                       MyButton(text: "Edit Info", iconData: Icons.app_registration, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 2),
                  //                       MyButton(text: "Manage Users", iconData: Icons.settings_applications, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(left: 20.0),
                  //                   child: GestureDetector(
                  //                     onTap: () {
                  //                       // auth.signOut();
                  //                       // Get.offAll(LogSign());
                  //                       showDialog(
                  //                           context: context,
                  //                           builder: (BuildContext context) {
                  //                             return AlertDialog(
                  //                               title: const Text("Logout Confirmation"),
                  //                               content: const Text("Are you sure you want to log out?"),
                  //                               actions: <Widget>[
                  //                                 FlatButton(
                  //                                     onPressed: () => {
                  //                                           signOut(),
                  //                                         },
                  //                                     child: const Text("Yes")),
                  //                                 FlatButton(
                  //                                   onPressed: () => Navigator.of(context).pop(false),
                  //                                   child: const Text("Cancel"),
                  //                                 ),
                  //                               ],
                  //                             );
                  //                           });
                  //                       print('clik');
                  //                     },
                  //                     child: Row(
                  //                       children: [
                  //                         Icon(
                  //                           Icons.logout,
                  //                           color: Color(0xff085078),
                  //                           size: 25.0,
                  //                         ),
                  //                         Text(
                  //                           '  Logout',
                  //                           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Nunito-Bold'),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
