import 'dart:async';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_rekk/pages/boarding.dart';
import 'package:get_rekk/pages/foradmin/dashboard.dart';
import 'package:get_rekk/pages/foradmin/fourth.dart';
import 'package:get_rekk/pages/foradmin/vehiclelist.dart';
import 'package:get_rekk/pages/forusers/editinfo.dart';
import 'package:get_rekk/pages/forusers/flagged.dart';
import 'package:get_rekk/pages/forusers/letstrry.dart';
import 'package:get_rekk/pages/forusers/loading.dart';
import 'package:get_rekk/pages/phoneverification.dart';
import 'package:get_rekk/pages/resetpassword.dart';
import 'package:http/http.dart' as http;
import 'package:get_rekk/pages/forusers/userssched.dart';
import 'package:get_rekk/pages/loginsignup.dart';
import 'package:get_rekk/pages/map.dart';
import 'package:get_rekk/pages/foradmin/newSched..dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'helpers/util.dart';
import 'dart:convert';

import 'pages/foradmin/first.dart';

List<CameraDescription> cameras = [];
FirebaseAuth auth = FirebaseAuth.instance;
User user = auth.currentUser;
//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";
Timer timer;
// flutter local notification setup
void showNotification(v, y, z, flp) async {
  var android = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(0, 'ACPRO3', '$v \n $y \n $z', platform, payload: 'ACPRO3 \n $v \n $y \n $z');
}

shownotif() async {
  // print('andito ako');
  FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
  User user = auth.currentUser;
  var android = AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOS = IOSInitializationSettings();
  var initSetttings = InitializationSettings(android: android, iOS: iOS);
  flp.initialize(initSetttings);
  List<String> oldcontent = [];

  oldcontent.add(user.uid);
  QuerySnapshot check = await FirebaseFirestore.instance.collection('flag').where('seen', arrayContains: user.uid).get();
  check.docs.forEach((document) async {
    print(document.data()['flaggedvehicles'].toString());
    print(document.data()['seen'].toString());
    showNotification(document.data()['lastflag'].toString(), document.data()['reason'].toString(), document.data()['otherreason'].toString(), flp);
    FirebaseFirestore.instance.collection('flag').doc(document.data()['flaggedvehicles'].toString()).update({
      'seen': FieldValue.arrayRemove(oldcontent),
    }).then((value) {});
  });
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // await Workmanager.initialize(callbackDispatcher, isInDebugMode: false); //to true if still in testing lev turn it to false whenever you are launching the app
    // await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
    //     existingWorkPolicy: ExistingWorkPolicy.replace,
    //     frequency: Duration(minutes: 15), //when should it check the link
    //     initialDelay: Duration(seconds: 5), //duration before showing the notification
    //     constraints: Constraints(
    //       networkType: NetworkType.connected,
    //     ));
    await Firebase.initializeApp();

    // Retrieve the device cameras
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CapstoneJS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: Splash(),
    );
  }
}

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

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) async {
//     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = IOSInitializationSettings();
//     var initSetttings = InitializationSettings(android: android, iOS: iOS);
//     flp.initialize(initSetttings);

//     // var response = await http.post('https://seeviswork.000webhostapp.com/api/testapi.php');
//     // print("here================");
//     // print(response);
//     // var convert = json.decode(response.body);
//     // if (convert['status'] == true) {
//     //   showNotification(convert['msg'], flp);
//     // } else {
//     //   print("no messgae");
//     // }
//     var a = await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: 'jpsanoza356@acpsone.com').get();
//     if (a.docs.isNotEmpty) {
//       // print('Exists');
//       // showNotification('true', flp);
//     }

//     return Future.value(true);
//   });
// }

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    UserSched.badge = '';
    UserSched.badgename = '';
    UserSched.date = "";
    UserSched.collectionid = "";
    UserSched.datecreated = null;
    UserSched.endtimeFormatted = "";
    UserSched.starttimeFormatted = "";
    UserSched.endtime = "";
    UserSched.starttime = "";
    UserSched.notes = "";
    UserSched.missionname = "";
    UserSched.kind = "";
    UserSched.location = "";
    UserSched.spotter = "";
    UserSched.teamlead = "";
    UserSched.spokesperson = "";
    UserSched.status = "";
    UserSched.createdby = "";
    UserSched.blockteamname.clear();
    UserSched.searchteamname.clear();
    UserSched.secuteamname.clear();
    UserSched.investteamname.clear();
    UserSched.blockteam.clear();
    UserSched.searchteam.clear();
    UserSched.secuteam.clear();
    UserSched.investteam.clear();
    UserSched.collectid.clear();

    Schedule.date = "";
    Schedule.collectionid = "";
    Schedule.datecreated = null;
    Schedule.endtimeFormatted = "";
    Schedule.starttimeFormatted = "";
    Schedule.endtime = "";
    Schedule.starttime = "";
    Schedule.notes = "";
    Schedule.missionname = "";
    Schedule.kind = "";
    Schedule.location = "";
    Schedule.spotter = "";
    Schedule.teamlead = "";
    Schedule.spokesperson = "";
    Schedule.status = "";
    Schedule.createdby = "";
    Schedule.blockteamname.clear();
    Schedule.searchteamname.clear();
    Schedule.secuteamname.clear();
    Schedule.investteamname.clear();
    Schedule.blockteam.clear();
    Schedule.searchteam.clear();
    Schedule.secuteam.clear();
    Schedule.investteam.clear();
    Schedule.lngloc = 0;
    Schedule.latloc = 0;

    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    var userLoggedin;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences level = await SharedPreferences.getInstance();
    SharedPreferences ppUrlSP = await SharedPreferences.getInstance();
    SharedPreferences fullNameSP = await SharedPreferences.getInstance();
    SharedPreferences rankSP = await SharedPreferences.getInstance();
    bool _seenxzz12355478911111 = (prefs.getBool('_seenxzz12355478911111') ?? false);
    if (_seenxzz12355478911111) {
      userLoggedin = user != null;
      if (userLoggedin) {
        UserLog.ppUrl = ppUrlSP.getString("ppUrlSP");
        UserLog.fullName = fullNameSP.getString("fullNameSP");
        UserLog.rank = rankSP.getString("rankSP");

        var a = level.getString("level");
        print(a);
        //edit logsign to check on db userlevel from registration// ill do this tomorrow
        if (a == 'user') {
          Get.offAll(UsersSched(), transition: Transition.fadeIn);
        } else {
          Get.offAll(Fourth(), transition: Transition.fade);
        }
      } else {
        Get.offAll(LogSign(), transition: Transition.fade);
      }
    } else {
      await prefs.setBool('_seenxzz12355478911111', true);
      Get.offAll(Boarding(), transition: Transition.fade);
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 4000), () {
      checkFirstSeen();
      timer = Timer.periodic(Duration(seconds: 10), (Timer t) => shownotif());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff85D8CE), Color(0xff085078)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
              child: Stack(
            children: <Widget>[
              Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff085078)),
              )),
            ],
          ))
        ],
      ),
    );
  }
}
