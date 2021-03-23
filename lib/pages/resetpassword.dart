import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:otp_text_field/style.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'loginsignup.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  RoundedLoadingButtonController _btnController;
  RoundedLoadingButtonController _btnController2;
  RoundedLoadingButtonController _btnController3;
  TextEditingController _contactRegTextController;
  TextEditingController _emailRegTextControllerx1;
  TextEditingController _rePasswordTextController;
  TextEditingController _frstPasswordTextController;
  TextEditingController _oldPasswordTextController;
  bool _passError = false;
  bool _passError2 = false;
  bool checkCurrentPasswordValid = true;
  GlobalKey _toolTipKey = GlobalKey();
  GlobalKey _toolTipKey2 = GlobalKey();
  GlobalKey _toolTipKey3 = GlobalKey();
  String phoneNo, verificationId, smsCode;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool codeSent = false;
  bool _blackVisible = false;
  bool _obscureText3 = true;
  bool _obscureText2 = true;
  bool _obscureText1 = true;
  bool codeReset = false;
  bool allGoods = false;
  String raw;
  String untouched;
  String edited;
  var uuid = Uuid();
  String finalemail;
  String finalpassword;

  void _pretoggle() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  void _toggleRe() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _oldpretoggle() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void initState() {
    _btnController = RoundedLoadingButtonController();
    _btnController2 = RoundedLoadingButtonController();
    _btnController3 = RoundedLoadingButtonController();
    _contactRegTextController = TextEditingController();
    _emailRegTextControllerx1 = TextEditingController();
    _rePasswordTextController = TextEditingController();
    _frstPasswordTextController = TextEditingController();
    _oldPasswordTextController = TextEditingController();

    super.initState();
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

  setup() {
    untouched = _contactRegTextController.text;
    _contactRegTextController.text = _contactRegTextController.text.substring(1);
    raw = '+63' + _contactRegTextController.text;
    print(raw);
    String formattedPhoneNumber = "(" + _contactRegTextController.text.substring(0, 3) + ") " + _contactRegTextController.text.substring(3, 6) + "-" + _contactRegTextController.text.substring(6, _contactRegTextController.text.length);
    setState(() {
      _contactRegTextController.text = '+63 ' + formattedPhoneNumber;
      edited = '+63 ' + formattedPhoneNumber;
    });
  }

  makeitrain() async {
    //raw
    //email
    var email = _emailRegTextControllerx1.text + '@acpsone.com';
    var usercheck;
    var isverified;
    var rawphonenumber;
    print(raw);
    print(_emailRegTextControllerx1.text + '@acpsone.com');
    QuerySnapshot username = await FirebaseFirestore.instance.collection('userlevel').where('email', isEqualTo: email).get();
    if (username.docs.isEmpty) {
      _showErrorAlert(
          title: "Email error.",
          content: 'Email is not from our organization.', //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      _btnController.reset();
    } else {
      username.docs.forEach((document) {
        usercheck = document.data()['fullName'];
        isverified = document.data()['isphoneverified'];
        rawphonenumber = document.data()['rawphonenumber'];
      });
      if (isverified == true) {
        if (rawphonenumber == raw) {
          print('all goods.');
          print('contact php now');
          verifyPhone(raw);
          _btnController.reset();
        } else {
          print('phone number is different from the verified one.');
          _showErrorAlert(
              title: "Different phone number detected.",
              content: 'Inserted phone number is not the same as the verified one.', //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          _btnController.reset();
        }
      } else {
        print(' you dont have any verified phone number.');
        _showErrorAlert(
            title: "Verification Error.",
            content: 'You do not have any verified phone number. \n Please contact your administrator to reset your password.', //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
        _btnController.reset();
      }
    }
  }

  String validatePassword(String value) {
    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter valid password';
      else
        return null;
    }
  }

  Future<bool> validatePasswordLast(String password) async {
    // User user = auth.currentUser;
    var firebaseUser = auth.currentUser;
    var authCredentials = EmailAuthProvider.credential(email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await validatePasswordLast(password);
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = auth.currentUser;
    firebaseUser.updatePassword(password);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        _btnController3.reset();
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // sendReqChange();
        // check(dropdownValue);
        // uploadPic();

        changeit();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        '''
Confirm changing your password?

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

  changeit() async {
    checkCurrentPasswordValid = await validateCurrentPassword(_oldPasswordTextController.text.toUpperCase());
    // _btnController1.reset();
    var collectionid2 = uuid.v1();
    User user = auth.currentUser;
    var currentUser = user.uid;
    var usercheck;
    var activity = 'Reset Password via Verified Phone Number.';
    if (checkCurrentPasswordValid == true) {
      print(checkCurrentPasswordValid);

      // try {
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
      username.docs.forEach((document) {
        usercheck = document.data()['fullName'];
      });

      updatePassword(_rePasswordTextController.text);

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
          'editcreate_collectionid': user.uid,
        });
      }).then((value) {
        FirebaseFirestore.instance.collection('userlevel').doc(user.uid).update({'generatedstring': ''});

        setState(() {
          Get.snackbar(
            "Success!",
            "Password verified successfully!",
            duration: Duration(seconds: 3),
          );
          Timer(Duration(seconds: 3), () {
            _btnController3.reset();
            auth.signOut();
            Get.offAll(LogSign());
          });
        });
      });
    } else {
      _showErrorAlert(
          title: "Password Update Failed.",
          content: "Unique ID is wrong!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      _btnController3.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: codeSent && codeReset
            ? Stack(
                children: <Widget>[
                  Container(
                      width: Get.width,
                      height: Get.height,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                      ),
                      child: SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0, left: 120),
                              child: Container(
                                height: 150,
                                width: 150,
                                child: Image.asset('assets/images/half3.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 190.0, right: 8, left: 8, bottom: 30),
                              child: Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(10.0),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 150, bottom: 10),
                                      child: Text(
                                        "Change Password",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontFamily: 'Nunito-Bold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 0),
                                      child: AutoSizeText('' + _emailRegTextControllerx1.text + '@acpsone.com', style: TextStyle(color: Colors.red, fontFamily: 'Nunito-Regular', fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        width: 480,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 0.0, left: 20),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Enter Unique String from SMS:",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      fontFamily: 'Nunito-Bold',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      final dynamic tooltip = _toolTipKey3.currentState;
                                                      tooltip.ensureTooltipVisible();
                                                    },
                                                    child: Tooltip(
                                                      key: _toolTipKey3,
                                                      // ignore: missing_required_param
                                                      child: IconButton(
                                                        icon: Icon(Icons.info, size: 20.0),
                                                      ),
                                                      message: 'Check your unique String in \nyour inbox.',
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
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 0),
                                              child: Container(
                                                width: 480,
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      maxLength: 10,
                                                      textCapitalization: TextCapitalization.characters,
                                                      controller: _oldPasswordTextController,
                                                      decoration: InputDecoration(
                                                        counterText: '',
                                                        isDense: true,
                                                        labelText: 'Unique',
                                                        prefixIcon: Icon(
                                                          Icons.lock_outline_sharp,
                                                          color: Color(0xff085078),
                                                        ),
                                                        contentPadding: EdgeInsets.only(left: 25.0),
                                                        hintText: "Unique",
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.grey, width: 2),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xff93F9B9), width: 2),
                                                          borderRadius: BorderRadius.circular(20.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 0.0, left: 20, top: 0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Enter New Password:",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
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
                                                        icon: Icon(Icons.info, size: 20.0),
                                                      ),
                                                      message: 'Common Allow Character (!@#*~)\n'
                                                          'Minimum 1 Upper case\n'
                                                          'Minimum 1 lower case\n'
                                                          'Minimum 1 Numeric Number\n'
                                                          'Minimum 1 Special Character\n'
                                                          'Minimum 8 characters & Maximum 15 characters\n',
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
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 0),
                                              child: Container(
                                                width: 480,
                                                child: Column(
                                                  children: [
                                                    Focus(
                                                      child: TextField(
                                                        maxLength: 15,
                                                        obscureText: _obscureText3,
                                                        controller: _frstPasswordTextController,
                                                        decoration: InputDecoration(
                                                          counterText: '',
                                                          isDense: true,
                                                          labelText: 'New Password',
                                                          prefixIcon: Icon(
                                                            Icons.lock_outline_sharp,
                                                            color: Color(0xff085078),
                                                          ),
                                                          contentPadding: EdgeInsets.only(left: 25.0),
                                                          hintText: "New Password",
                                                          suffixIcon: GestureDetector(
                                                            onTap: () {
                                                              _pretoggle();
                                                            },
                                                            child: Icon(_obscureText3 ? Icons.visibility_off : Icons.visibility),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: _passError ? BorderSide(color: Colors.red, width: 2) : BorderSide(color: Colors.grey, width: 2),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Color(0xff93F9B9), width: 2),
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                        ),
                                                      ),
                                                      onFocusChange: (hasFocus) {
                                                        setState(() {});
                                                        if (!hasFocus) {
                                                          bool passValid = RegExp("^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*").hasMatch(_frstPasswordTextController.text);

                                                          if (_frstPasswordTextController.text.isEmpty || !passValid || _frstPasswordTextController.text.length < 8) {
                                                            print('error password error');
                                                            _passError = true;
                                                          } else {
                                                            if (_rePasswordTextController.text.isNotEmpty && _rePasswordTextController.text != _frstPasswordTextController.text) {
                                                              _passError = true;
                                                            } else {
                                                              _passError = false;
                                                              print('goods');
                                                            }
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 0.0, left: 20, top: 0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Re-Enter New Password:",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      fontFamily: 'Nunito-Bold',
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      final dynamic tooltip = _toolTipKey2.currentState;
                                                      tooltip.ensureTooltipVisible();
                                                    },
                                                    child: Tooltip(
                                                      key: _toolTipKey2,
                                                      // ignore: missing_required_param
                                                      child: IconButton(
                                                        icon: Icon(Icons.info, size: 20.0),
                                                      ),
                                                      message: 'Common Allow Character (!@#*~)\n'
                                                          'Minimum 1 Upper case\n'
                                                          'Minimum 1 lower case\n'
                                                          'Minimum 1 Numeric Number\n'
                                                          'Minimum 1 Special Character\n'
                                                          'Minimum 8 characters & Maximum 15 characters\n',
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
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 12.0, left: 12, top: 0, bottom: 0),
                                              child: Container(
                                                width: 480,
                                                child: Column(
                                                  children: [
                                                    Focus(
                                                      child: TextField(
                                                        maxLength: 15,
                                                        obscureText: _obscureText2,
                                                        controller: _rePasswordTextController,
                                                        decoration: InputDecoration(
                                                          counterText: '',
                                                          isDense: true,
                                                          labelText: 'Re-enter Password',
                                                          prefixIcon: Icon(
                                                            Icons.lock_outline_sharp,
                                                            color: Color(0xff085078),
                                                          ),
                                                          contentPadding: EdgeInsets.only(left: 25.0),
                                                          hintText: "Re-enter Password",
                                                          suffixIcon: GestureDetector(
                                                            onTap: () {
                                                              _toggleRe();
                                                            },
                                                            child: Icon(_obscureText2 ? Icons.visibility_off : Icons.visibility),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: _passError2 ? BorderSide(color: Colors.red, width: 2) : BorderSide(color: Colors.grey, width: 2),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Color(0xff93F9B9), width: 2),
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                        ),
                                                      ),
                                                      onFocusChange: (hasFocus) {
                                                        setState(() {});
                                                        if (!hasFocus) {
                                                          bool passValid = RegExp("^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*").hasMatch(_rePasswordTextController.text);
                                                          if (_rePasswordTextController.text.isEmpty || !passValid || _rePasswordTextController.text.length < 8) {
                                                            print('error password error');
                                                            _passError2 = true;
                                                          } else {
                                                            if (_frstPasswordTextController.text != _rePasswordTextController.text) {
                                                              _passError2 = true;
                                                            } else {
                                                              setState(() {
                                                                finalpassword = _rePasswordTextController.text;
                                                                finalemail = _emailRegTextControllerx1.text + '@acpsone.com';
                                                                _passError2 = false;
                                                                allGoods = true;
                                                                print('goods');
                                                              });
                                                            }
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20.0, right: 0, left: 0, bottom: 0),
                                              child: Container(
                                                // height: 200,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        RoundedLoadingButton(
                                                          color: Color(0xff085078),
                                                          child: Text('Change Password', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                                          controller: _btnController3,
                                                          onPressed: () {
                                                            //  sendData();

                                                            if (allGoods == true && _oldPasswordTextController.text.length > 8) {
                                                              // _showSuccessAlert(
                                                              //     title: "Verification completed.",
                                                              //     content: "Congrats your password has\n been change!", //show error firebase
                                                              //     onPressed: _changeBlackVisible,
                                                              //     context: context);

                                                              setState(() {
                                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                showAlertDialog(context);
                                                                // _btnController3.reset();
                                                                // showAlertDialog2(context);
                                                                // changePass();
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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
                          ],
                        ),
                      )),
                ],
              )
            : SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: Get.width,
                      height: Get.height,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                      ),
                      child: codeSent
                          ? Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 160.0, left: 30),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.asset('assets/images/half2.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0, left: 140),
                                  child: Container(
                                    height: 300,
                                    width: 240,
                                    child: Image.asset('assets/images/bubblemirror.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 130.0, left: 160),
                                  child: Text('Please enter the\n 6-digit OTP code.', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 20)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 300),
                                  child: Container(
                                    width: Get.width,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.circular(10.0),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                    ),
                                    child: SafeArea(
                                      child: Container(
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 28.0, right: 27, bottom: 10),
                                              child: AutoSizeText('*Enter the 6-digit OTP code to be verified.', style: TextStyle(color: Colors.red, fontFamily: 'Nunito-Regular', fontSize: 15)),
                                            ),

                                            //here ang contents
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                                              child: OTPTextField(
                                                length: 6,
                                                width: 330,
                                                fieldWidth: 50,
                                                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w400),
                                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                                fieldStyle: FieldStyle.box,
                                                onCompleted: (pin) {
                                                  print("Completed: " + pin);
                                                  setState(() {
                                                    this.smsCode = pin;
                                                  });
                                                },
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 0.0, right: 20, left: 20, bottom: 30),
                                              child: Container(
                                                // height: 200,
                                                // width: 200,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        RoundedLoadingButton(
                                                          color: Color(0xff085078),
                                                          child: Text('Verify', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                                          controller: _btnController2,
                                                          onPressed: () {
                                                            setState(() {
                                                              signIn();

                                                              FocusScope.of(context).requestFocus(new FocusNode());
                                                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                            });
                                                          },
                                                        ),
                                                      ],
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
                            )
                          : SingleChildScrollView(
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 160.0, left: 230),
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Image.asset('assets/images/half.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0, left: 20),
                                    child: Container(
                                      height: 300,
                                      width: 250,
                                      child: Image.asset('assets/images/bubble.png'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 130.0, left: 40),
                                    child: Text('Resetting your password is easy. ', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 14)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 160.0, left: 40),
                                    child: Text('The system will send you a random\n string of text which you can then use\n to change your password.. ', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 12)),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 300, bottom: 30),
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
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 28.0, right: 27, bottom: 10),
                                                      child: AutoSizeText('*If you have verified your phone number before, you can use this way of resetting your password.', style: TextStyle(color: Colors.green, fontFamily: 'Nunito-Regular', fontSize: 15)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 28.0, right: 27, bottom: 20, top: 0),
                                                      child: AutoSizeText('*If you have not verified your phone number before, you can contact your administrator to request for a new password.', style: TextStyle(color: Colors.red, fontFamily: 'Nunito-Regular', fontSize: 15)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 30.0, left: 30, top: 0, bottom: 12),
                                                      child: Container(
                                                        width: 480,
                                                        child: Column(
                                                          children: [
                                                            TextField(
                                                              readOnly: false,
                                                              controller: _emailRegTextControllerx1,
                                                              maxLength: 32,
                                                              onChanged: (String value) async {},
                                                              inputFormatters: [
                                                                new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                                                              ],
                                                              decoration: InputDecoration(
                                                                  counterText: '',
                                                                  suffixText: new TextSpan(text: '@acpsone.com  ').text,
                                                                  isDense: true,
                                                                  prefixIcon: IconButton(
                                                                    color: Color(0xff085078),
                                                                    icon: Icon(Icons.mail_outline_sharp),
                                                                    iconSize: 20.0,
                                                                    onPressed: () {},
                                                                  ),
                                                                  contentPadding: EdgeInsets.only(left: 25.0),
                                                                  hintText: 'Email',
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 30.0, left: 30, top: 10, bottom: 30),
                                                      child: Container(
                                                        width: 480,
                                                        child: Column(
                                                          children: [
                                                            Focus(
                                                              child: TextField(
                                                                keyboardType: TextInputType.phone,
                                                                maxLength: 11,
                                                                controller: _contactRegTextController,
                                                                maxLengthEnforced: true,
                                                                inputFormatters: [
                                                                  new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                                ],
                                                                decoration: InputDecoration(
                                                                    counterText: '',
                                                                    isDense: true,
                                                                    prefixIcon: IconButton(
                                                                      color: Color(0xff085078),
                                                                      icon: Icon(Icons.contact_page),
                                                                      iconSize: 20.0,
                                                                      onPressed: () {},
                                                                    ),
                                                                    contentPadding: EdgeInsets.only(left: 25.0),
                                                                    hintText: 'Phone number',
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                                                              ),
                                                              onFocusChange: (hasFocus) {
                                                                if (!hasFocus) {
                                                                  // do stuff
                                                                  setup();
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0.0, right: 20, left: 20, bottom: 30),
                                                      child: Container(
                                                        // height: 200,
                                                        // width: 200,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                RoundedLoadingButton(
                                                                  color: Color(0xff085078),
                                                                  child: Text('Send Random Password', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                                                  controller: _btnController,
                                                                  onPressed: () {
                                                                    if (_contactRegTextController.text == '' || _emailRegTextControllerx1.text == '') {
                                                                      _showErrorAlert(
                                                                          title: "Verification failed.",
                                                                          content: 'All fields required.', //show error firebase
                                                                          onPressed: _changeBlackVisible,
                                                                          context: context);
                                                                      _btnController.reset();
                                                                    } else {
                                                                      setState(() {
                                                                        // _showSuccessAlert(
                                                                        //     title: "Please wait while the system checks if you have a valid credentials.",
                                                                        //     content: "Waiting.", //show error firebase
                                                                        //     onPressed: _changeBlackVisible,
                                                                        //     context: context);
                                                                        makeitrain();
                                                                        // Timer(Duration(seconds: 3), () {
                                                                        //   // verifyPhone(raw);
                                                                        //   _btnController.reset();
                                                                        // });
                                                                        FocusScope.of(context).requestFocus(new FocusNode());
                                                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                              ],
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
                                      ),
                                    ],
                                  ),
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

  signIn() async {
    // codeReset = true;
    String errorMessage;
    var usercheck;
    var collectionid2 = uuid.v1();
    var activity = 'Phone number verified.';
    var email = _emailRegTextControllerx1.text + '@acpsone.com';
    var codefromphp;
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);

      if (result != null) {
        // try {
        var url = 'https://capstonejs.000webhostapp.com/totalchange.php';
        var data = {
          'emailSignup': email,
          'number': untouched,
        };
        var response = await http.post(url, body: jsonEncode(data));
        codefromphp = response.body;
        print(response.body.length);
        if (response.body.length > 11) {
          _showErrorAlert(
              title: "Backend failed.",
              content: 'Please Try Again Later.', //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          _btnController2.reset();
          // auth.signOut();
          // Get.to(LogSign());
          codeReset = false;
        } else {
          _showSuccessAlert(
              title: "Verification completed.",
              content: "We will send you an sms containing the unique key that you can use on the next page.", //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          Timer(Duration(seconds: 7), () {
            setState(() {
              _btnController2.reset();
              codeReset = true;
            });
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      print('imhere' + e.toString());

      switch (e.code) {
        case "unknown":
          errorMessage = "User has already been linked to the given provider.";
          _showErrorAlert(
              title: "Verification failed.",
              content: errorMessage, //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          break;
        case "invalid-verification-code":
          errorMessage = " The sms verification code used to create the phone link credential is invalid.";
          _showErrorAlert(
              title: "Verification failed.",
              content: errorMessage, //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

      _btnController2.reset();
    }
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential) {
      print("Verified");
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      setState(() {
        verificationId = verId;
        codeSent = true;
      });
    };

    final PhoneVerificationFailed verfifailed = (FirebaseAuthException exception) {
      print("${exception.message}");

      print("falied");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phoneNo, codeAutoRetrievalTimeout: autoRetrieval, codeSent: smsCodeSent, timeout: const Duration(seconds: 50), verificationCompleted: verifiedSuccess, verificationFailed: verfifailed);
  }
}
