import 'dart:async';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_rekk/pages/boarding.dart';
import 'package:get_rekk/pages/loginsignup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/cameratrial.dart';
import 'pages/third.dart';

List<CameraDescription> cameras = [];

// void main() {
//   runApp(MyApp());
// }
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
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seenxzz1234 = (prefs.getBool('_seenxzz1234') ?? false);
    if (_seenxzz1234) {
      Get.offAll(LogSign(), transition: Transition.fade);
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
