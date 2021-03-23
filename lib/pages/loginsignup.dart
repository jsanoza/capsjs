import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/animated_wave.dart';
import 'package:get_rekk/animations/bubble_indication_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/phoneverification.dart';
import 'package:get_rekk/pages/resetpassword.dart';
import 'package:rect_getter/rect_getter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'foradmin/fourth.dart';

import 'forusers/userssched.dart';

class LogSign extends StatefulWidget {
  LogSign({Key key}) : super(key: key);

  @override
  _LogSignState createState() => new _LogSignState();
}

class _LogSignState extends State<LogSign> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _blackVisible = false;
  PageController _pageController;
  Color left = Colors.black;
  Color right = Colors.white;
  bool isRequ = true;
  bool isRequ2 = false;
  bool _obscureText3 = true;
  bool isPhoneVerified = false;
  String isPhoneVer;

  var data;
  var ppUrlx;
  var fullnamex;
  var rankx;
  var uuid = Uuid();

  final Duration animationDuration = Duration(milliseconds: 500);
  final Duration delay = Duration(milliseconds: 100);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;

  void _onTap() async {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => rect = rect.inflate(1.3 * context.mediaQuerySize.longestSide));
      Future.delayed(animationDuration + delay, _goToNextPage);
    });
  }

  void _goToNextPage() {
    if (data == 'user' && isPhoneVer.toString() == 'true') {
      Get.offAll(UsersSched(), transition: Transition.fadeIn);
    } else if (data == 'user' && isPhoneVer.toString() == 'false') {
      // Get.offAll(Fourth(), transition: Transition.fadeIn);
      Get.offAll(
          Phone(
            isVerified: false,
            fromWhere: 'editUser',
          ),
          transition: Transition.fadeIn);
    } else if (data == 'admin') {
      Get.offAll(Fourth(), transition: Transition.fadeIn);
    }
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: Get.width - rect.right,
      top: rect.top,
      bottom: Get.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xff85D8CE), Color(0xff085078), Colors.white], center: Alignment(0.1, 0.2))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 56, bottom: 228),
        child: RectGetter(
            key: rectGetterKey,
            child: Padding(
              padding: const EdgeInsets.all(0),
            )),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: Get.height,
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
              ),
            ),
            NotificationListener<OverscrollIndicatorNotification>(
              // ignore: missing_return
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: Container(
                height: Get.height,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 80.0, bottom: 30, left: 18, right: 18),
                      child: new Image(width: Get.width, height: 150.0, fit: BoxFit.contain, image: new AssetImage('assets/images/logo1.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 230.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildMenuBar(context),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 270.0),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              isRequ = true;
                              isRequ2 = false;
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              isRequ = false;
                              isRequ2 = true;
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: Get.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    child: AnimatedWave(
                      color: Color(0xff85D8CE),
                      height: 80,
                      speed: 0.7,
                    ),
                  ),
                  Container(
                    child: AnimatedWave(
                      color: Color(0xff3f4c6b),
                      height: 60,
                      speed: 1.0,
                      offset: pi,
                    ),
                  ),
                  Container(
                    child: AnimatedWave(
                      color: Color(0xff085078),
                      height: 60,
                      speed: 1.4,
                      offset: pi / 2,
                    ),
                  ),
                ],
              ),
            ),
            _ripple(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void _pretoggle() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
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

  void handleSignIn() async {
    var email = _emailTextController.text.trim() + '@acpsone.com';
    var password = _passwordTextController.text.trim();
    SharedPreferences level = await SharedPreferences.getInstance();
    SharedPreferences ppUrlSP = await SharedPreferences.getInstance();
    SharedPreferences fullNameSP = await SharedPreferences.getInstance();
    SharedPreferences rankSP = await SharedPreferences.getInstance();
    String errorMessage;

    // _onTap();
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);

      if (result != null) {
        var a = await FirebaseFirestore.instance.collection('userlevel').where("email", isEqualTo: email).get();
        var b = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
        if (a.docs.isNotEmpty && b.docs.isNotEmpty) {
          // print('Exists');
          var hello = a.docs[0];
          var hello2 = b.docs[0];
          data = hello.data()['level'];
          ppUrlx = hello2.data()['picUrl'];
          fullnamex = hello2.data()['fullName'];
          rankx = hello2.data()['rank'];
          isPhoneVer = hello.data()['isphoneverified'].toString();
          await level.setString('level', data);
          await ppUrlSP.setString('ppUrlSP', ppUrlx);
          await fullNameSP.setString('fullNameSP', fullnamex);
          await rankSP.setString('rankSP', rankx);

          UserLog.ppUrl = hello2.data()['picUrl'];
          UserLog.fullName = hello2.data()['fullName'];
          UserLog.rank = hello2.data()['rank'];
          User user = auth.currentUser;

          print(level.getString("level"));
          var collectionid2 = uuid.v1();

          FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
            'lastactivity_datetime': Timestamp.now(),
          }).then((value) {
            FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
              'userid': user.uid,
              'activity': 'User logged into session.',
              'editcreate_datetime': Timestamp.now(),
            });
          }).then((value) {
            // auth.signOut();
            // Get.offAll(LogSign());

            _onTap();
          });
        }
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorMessage = "Email already used. Go to login page.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          errorMessage = "Wrong email/password combination.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorMessage = "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorMessage = "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          errorMessage = "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorMessage = "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "Email address is invalid.";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
          break;
      }
      _showErrorAlert(
          title: "LOGIN FAILED",
          content: errorMessage, //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      // showErrDialog(context, errorMessage);
    }
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Row(
                  children: [
                    isRequ ? RotatedBox(quarterTurns: 0, child: Icon(Icons.push_pin, size: 20, color: Color(0xff85D8CE))) : RotatedBox(quarterTurns: 3, child: Icon(Icons.push_pin, size: 20, color: right)),
                    VerticalDivider(
                      color: Colors.transparent,
                    ),
                    Text(
                      "SIGN IN",
                      style: TextStyle(color: right, fontSize: 15, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Row(
                  children: [
                    isRequ2 ? RotatedBox(quarterTurns: 0, child: Icon(Icons.push_pin, size: 20, color: Color(0xff85D8CE))) : RotatedBox(quarterTurns: 3, child: Icon(Icons.push_pin, size: 20, color: left)),
                    VerticalDivider(
                      color: Colors.transparent,
                    ),
                    Text(
                      "INFO",
                      style: TextStyle(color: left, fontSize: 15, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
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
        height: 60,
        width: 60,
        child: Stack(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  // _onTap();
                  handleSignIn();
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
                    child: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 5.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: Get.width,
                  height: 200.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: TextField(
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                //controller here
                                controller: _emailTextController,
                                maxLength: 32,
                                inputFormatters: [
                                  new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                                ],

                                decoration: InputDecoration(
                                  suffixText: new TextSpan(text: '@acps...').text,
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.mail_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  hintText: "Email",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff85D8CE), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                // onChanged: (val) {
                                //   email = val;
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0, left: 30, top: 20),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              // child: _passwordfieldxasd,
                              child: TextField(
                                obscureText: _obscureText3,
                                maxLength: 30,
                                //controller here
                                controller: _passwordTextController,
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                  hintText: "Password",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _pretoggle();
                                    },
                                    child: Icon(_obscureText3 ? Icons.visibility_off : Icons.visibility),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff85D8CE), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                // onChanged: (val) {
                                //   password = val;
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 120.0, left: 190),
                  child: _buildLoginBtn(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
              onPressed: () {
                Get.to(ResetPassword());
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(decoration: TextDecoration.underline, color: Colors.white, fontSize: 15, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w400),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 0.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white10,
          //                 Colors.white,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: 100.0,
          //         height: 1.0,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 15.0, right: 15.0),
          //         child: Text(
          //           "Or",
          //           style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "Nunito"),
          //         ),
          //       ),
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white,
          //                 Colors.white10,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: 100.0,
          //         height: 1.0,
          //       ),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.only(top: 10.0, right: 0.0),
          //       child: Container(
          //         decoration: new BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(60),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.white,
          //               blurRadius: 40.0, // soften the shadow
          //               spreadRadius: 0.0, //extend the shadow
          //               offset: Offset(
          //                 0.0, // Move to right 10  horizontally
          //                 -20.0, // Move to bottom 10 Vertically
          //               ),
          //             )
          //           ],
          //         ),
          //         child: Stack(
          //           children: <Widget>[
          //             Center(
          //               child: new IconButton(
          //                   icon: Image.asset('assets/images/gg.png'),
          //                   iconSize: 40,
          //                   onPressed: () {
          //                     print("Google clicked");
          //                     // signInWithGoogle();
          //                     // onPressed:
          //                     // () => signInWithGoogle().whenComplete(() async {
          //                     //       // User user = await FirebaseAuth.instance();
          //                     //       FirebaseAuth auth = FirebaseAuth.instance;
          //                     //       User user = auth.currentUser;

          //                     //       // Navigator.of(context).pushReplacement(
          //                     //       //     MaterialPageRoute(
          //                     //       //         builder: (context) =>
          //                     //       //             Third(uid: user.uid)));
          //                     //       Get.to(Third());
          //                     //     })
          //                     Get.to(Third());
          //                   }),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     // Padding(
          //     //   padding: EdgeInsets.only(top: 10.0),
          //     //   child: Container(
          //     //     decoration: new BoxDecoration(
          //     //       color: Colors.white,
          //     //       borderRadius: BorderRadius.circular(60),
          //     //       boxShadow: [
          //     //         BoxShadow(
          //     //           color: Colors.white,
          //     //           blurRadius: 40.0, // soften the shadow
          //     //           spreadRadius: 0.0, //extend the shadow
          //     //           offset: Offset(
          //     //             0.0, // Move to right 10  horizontally
          //     //             -20.0, // Move to bottom 10 Vertically
          //     //           ),
          //     //         )
          //     //       ],
          //     //     ),
          //     //     child: Stack(
          //     //       children: <Widget>[
          //     //         Center(
          //     //           child: new IconButton(
          //     //             icon: Image.asset('assets/images/fb.png'),
          //     //             iconSize: 40,
          //     //             onPressed: () {
          //     //               print("Facebook clicked");
          //     //               // handleFacebookSignInz();
          //     //             },
          //     //           ),
          //     //         ),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }

//THIS IS WHERE I AM NOW<< ILL DO THIS TOMORROW!
  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 330.0,
                  height: 320.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text('Welcome Officer!', style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0, left: 10, right: 10),
                        child: Text('To use this app, you should: ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                        child: Text('Get your login credentials from your administrator. ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                        child: Text('Once you logged in, verify your phone number. ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
                        child: Text('In case you forgot your password, you should: ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                        child: Text('Request for a password change link, then the system  ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                        child: Text('will send you a link to your verified phone number in ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                        child: Text('order to change your password.', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
                        child: Text('In case you did not verify your phone number, you should: ', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                        child: Text('Contact your administrator.', style: TextStyle(fontSize: 12)),
                      ),
                      // Image.asset('assets/images/info.png'),
                    ],
                  ),
                ),
              ),
              // Container(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 290.0),
              //     child: Container(
              //       decoration: new BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(blurRadius: 12, offset: Offset(0, 1), color: Colors.white.withOpacity(.3), spreadRadius: 8)]),
              //       width: 250,
              //       child: _buildSignupbtn(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
