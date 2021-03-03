import 'dart:async';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_rekk/pages/boarding.dart';
import 'package:get_rekk/pages/foradmin/dashboard.dart';
import 'package:get_rekk/pages/foradmin/vehiclelist.dart';
import 'package:get_rekk/pages/forusers/editinfo.dart';
import 'package:get_rekk/pages/forusers/letstrry.dart';
import 'package:get_rekk/pages/forusers/loading.dart';

import 'package:get_rekk/pages/forusers/userssched.dart';
import 'package:get_rekk/pages/loginsignup.dart';
import 'package:get_rekk/pages/map.dart';
import 'package:get_rekk/pages/foradmin/newSched..dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/util.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
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
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: Splash(),
    );
  }
}

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
    bool _seenxzz1234 = (prefs.getBool('_seenxzz1234') ?? false);
    if (_seenxzz1234) {
      userLoggedin = user != null;
      if (userLoggedin) {
        var a = level.getString("level");
        print(a);
        //edit logsign to check on db userlevel from registration// ill do this tomorrow
        if (a == 'user') {
          Get.offAll(UsersSched(), transition: Transition.fadeIn);
        } else {
          Get.offAll(Dashboard(), transition: Transition.fade);
        }
      } else {
        Get.offAll(LogSign(), transition: Transition.fade);
      }
    } else {
      await prefs.setBool('_seenxzz1234', true);
      Get.offAll(Boarding(), transition: Transition.fade);
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 4000), () {
      checkFirstSeen();
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
                colors: [
                  Color(0xff1D976C),
                  Color(0xff93F9B9),
                ],
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
              )),
            ],
          ))
        ],
      ),
    );
  }
}
