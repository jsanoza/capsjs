import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/animated_wave.dart';
import 'package:get_rekk/animations/bubble_indication_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dashboard.dart';

class LogSign extends StatefulWidget {
  LogSign({Key key}) : super(key: key);

  @override
  _LogSignState createState() => new _LogSignState();
}

class _LogSignState extends State<LogSign> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  PageController _pageController;
  Color left = Colors.black;
  Color right = Colors.white;
  bool isRequ = true;
  bool isRequ2 = false;
  bool _obscureText3 = true;
  bool _obscureText2 = true;
  bool _obscureText = true;

  final Duration animationDuration = Duration(milliseconds: 500);
  final Duration delay = Duration(milliseconds: 100);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;

  void _onTap() async {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(
          () => rect = rect.inflate(1.3 * context.mediaQuerySize.longestSide));
      Future.delayed(animationDuration + delay, _goToNextPage);
    });
  }

  void _goToNextPage() {
    Get.offAll(Dashboard(), transition: Transition.fadeIn);
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
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
                colors: [Color(0xff1D976C), Color(0xff93F9B9), Colors.white],
                center: Alignment(0.1, 0.2))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Scaffold(
          key: _scaffoldKey,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 56, bottom: 228),
            child: RectGetter(
                key: rectGetterKey,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                )),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [Color(0xff93F9B9), Color(0xff1D976C)],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 80.0),
                          child: new Image(
                              width: 200.0,
                              height: 150.0,
                              fit: BoxFit.contain,
                              image: new AssetImage('assets/images/logo2.png')),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: _buildMenuBar(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
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
                    Expanded(
                      flex: 2,
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
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          child: AnimatedWave(
                            color: Color(0xff1D976C),
                            height: 80,
                            speed: 0.7,
                          ),
                        ),
                        Container(
                          child: AnimatedWave(
                            color: Color(0xff87d4c5),
                            height: 60,
                            speed: 1.0,
                            offset: pi,
                          ),
                        ),
                        Container(
                          child: AnimatedWave(
                            color: Color(0xff93F9B9),
                            height: 60,
                            speed: 1.4,
                            offset: pi / 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _ripple(),
      ],
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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleRe() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
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
                    isRequ
                        ? RotatedBox(
                            quarterTurns: 0,
                            child: Icon(Icons.push_pin,
                                size: 20, color: Color(0xff1D976C)))
                        : RotatedBox(
                            quarterTurns: 3,
                            child:
                                Icon(Icons.push_pin, size: 20, color: right)),
                    VerticalDivider(
                      color: Colors.transparent,
                    ),
                    Text(
                      "SIGN IN",
                      style: TextStyle(
                          color: right,
                          fontSize: 15,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400),
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
                    isRequ2
                        ? RotatedBox(
                            quarterTurns: 0,
                            child: Icon(Icons.push_pin,
                                size: 20, color: Color(0xff1D976C)))
                        : RotatedBox(
                            quarterTurns: 3,
                            child: Icon(Icons.push_pin, size: 20, color: left)),
                    VerticalDivider(
                      color: Colors.transparent,
                    ),
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: left,
                          fontSize: 15,
                          fontFamily: 'Nunito-Regular',
                          fontWeight: FontWeight.w400),
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

  Widget _buildSignupbtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Stack(
        children: <Widget>[
          Center(
              child: Container(
            child: RoundedLoadingButton(
              color: Color(0xff1D976C),
              child: Text('Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito-Regular',
                      fontSize: 18)),
              controller: _btnController,
              onPressed: () {
                //   _signUp(
                //       email: _emailSup.text,
                //       password: _passwordSup.text,
                //       context: context);
                // }, //_doSomething next
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
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
                  _onTap();
                  // _emailLogin(
                  //     email: _email.text,
                  //     password: _password.text,
                  //     context: context);
                }, //only after checking
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff93F9B9), Color(0xff1D976C)],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 88.0,
                        minHeight: 36.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Icon(Icons.arrow_forward_ios,
                        size: 20, color: Colors.white),
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
      padding: EdgeInsets.only(top: 10.0),
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
                  width: 330.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 20),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: TextField(
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                //controller here
                                maxLength: 60,
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Email',
                                  icon: Icon(Icons.mail_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Email",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff93F9B9), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, left: 30, top: 20),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              // child: _passwordfieldxasd,
                              child: TextField(
                                obscureText: _obscureText3,
                                maxLength: 30,
                                //controller here
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Password",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _pretoggle();
                                    },
                                    child: Icon(_obscureText3
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff93F9B9), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 120.0, left: 190),
                  child: _buildLoginBtn(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Nunito-Regular',
                      fontWeight: FontWeight.w400),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
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
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "Nunito"),
                  ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 40.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          -20.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: new IconButton(
                          icon: Image.asset('assets/images/gg.png'),
                          iconSize: 40,
                          onPressed: () {
                            print("Google clicked");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 40.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          -20.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: new IconButton(
                          icon: Image.asset('assets/images/fb.png'),
                          iconSize: 40,
                          onPressed: () {
                            print("Facebook clicked");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 17),
                        child: Row(
                          children: <Widget>[
                            // new Expanded(child: _emailFieldSup),
                            new Expanded(
                              child: TextField(
                                obscureText: false,
                                //controller here
                                maxLength: 60,
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.account_box),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Name",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff93F9B9), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 20),
                        child: Row(
                          children: <Widget>[
                            // new Expanded(child: _emailFieldSup),
                            new Expanded(
                              child: TextField(
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                maxLength: 60,
                                //controller here
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.mail_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Email",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff93F9B9), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, left: 30, top: 20),
                        child: Row(
                          children: <Widget>[
                            // new Expanded(
                            //   child: _passwordfieldSup,
                            // ),
                            new Expanded(
                              child: TextField(
                                obscureText: _obscureText,
                                maxLength: 30,
                                //controller here
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Password",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _toggle();
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff93F9B9), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, left: 30, top: 20),
                        child: Row(
                          children: <Widget>[
                            // new Expanded(
                            //   child: _repasswordfieldSup,
                            // ),
                            new Expanded(
                              child: TextField(
                                obscureText: _obscureText2,
                                maxLength: 30,
                                //controller here
                                decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  labelText: 'Re-Enter Password',
                                  prefixIcon: Icon(Icons.lock_outline_sharp),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Re-Enter Password",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _toggleRe();
                                    },
                                    child: Icon(_obscureText2
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff93F9B9), width: 2),
                                    borderRadius: BorderRadius.circular(20.0),
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 290.0),
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 12,
                              offset: Offset(0, 1),
                              color: Colors.white.withOpacity(.3),
                              spreadRadius: 8)
                        ]),
                    width: 250,
                    child: _buildSignupbtn(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
