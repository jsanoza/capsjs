import 'package:flutter/material.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import 'foradmin/editinfo.dart';
import 'forusers/editinfo.dart';

class ChangePhone extends StatefulWidget {
  final bool isVerified;
  final String fromWhere;

  const ChangePhone({Key key, this.isVerified, this.fromWhere}) : super(key: key);
  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  final formKey = new GlobalKey<FormState>();
  RoundedLoadingButtonController _btnController;
  RoundedLoadingButtonController _btnController2;
  TextEditingController _contactRegTextController;
  TextEditingController _oldContactRegTextController;
  TextEditingController _newContactRegTextController;
  String phoneNo, verificationId, smsCode;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool codeSent = false;
  bool _blackVisible = false;
  String raw;
  String edited;
  String oldVerifiedPhone;
  String showOldVerifiedPhone;
  String rawOldVerifiedPhone;
  String rawNewVerifiedPhone;
  var uuid = Uuid();

  @override
  void initState() {
    _btnController = RoundedLoadingButtonController();
    _btnController2 = RoundedLoadingButtonController();
    _contactRegTextController = TextEditingController();
    _oldContactRegTextController = TextEditingController();
    _newContactRegTextController = TextEditingController();
    print(widget.fromWhere);
    if (widget.fromWhere == 'editAdmin') {
      oldVerifiedPhone = auth.currentUser.phoneNumber;
      showOldVerifiedPhone = '0' + oldVerifiedPhone.substring(3);
      showOldVerifiedPhone = showOldVerifiedPhone.substring(0, 4) + '***' + showOldVerifiedPhone.substring(7, 11);
      print(showOldVerifiedPhone);
    } else if (widget.fromWhere == 'editUser') {
      oldVerifiedPhone = auth.currentUser.phoneNumber == null ? '0000000000000' : auth.currentUser.phoneNumber;
      showOldVerifiedPhone = '0' + oldVerifiedPhone.substring(3);
      showOldVerifiedPhone = showOldVerifiedPhone.substring(0, 4) + '***' + showOldVerifiedPhone.substring(7, 11);
      print(showOldVerifiedPhone);
    }
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

  // setup() {
  //   _contactRegTextController.text = _contactRegTextController.text.substring(1);
  //   raw = '+63' + _contactRegTextController.text;
  //   print(raw);
  //   String formattedPhoneNumber = "(" + _contactRegTextController.text.substring(0, 3) + ") " + _contactRegTextController.text.substring(3, 6) + "-" + _contactRegTextController.text.substring(6, _contactRegTextController.text.length);

  //   setState(() {
  //     _contactRegTextController.text = '+63 ' + formattedPhoneNumber;
  //     edited = '+63 ' + formattedPhoneNumber;
  //   });
  // }

  setup1() {
    _oldContactRegTextController.text = _oldContactRegTextController.text.substring(1);
    rawOldVerifiedPhone = '+63' + _oldContactRegTextController.text;
    String formattedPhoneNumber = "(" + _oldContactRegTextController.text.substring(0, 3) + ") " + _oldContactRegTextController.text.substring(3, 6) + "-" + _oldContactRegTextController.text.substring(6, _oldContactRegTextController.text.length);

    setState(() {
      _oldContactRegTextController.text = '+63 ' + formattedPhoneNumber;
      edited = '+63 ' + formattedPhoneNumber;
    });
  }

  setup2() {
    _newContactRegTextController.text = _newContactRegTextController.text.substring(1);
    rawNewVerifiedPhone = '+63' + _newContactRegTextController.text;
    print(rawNewVerifiedPhone);
    String formattedPhoneNumber = "(" + _newContactRegTextController.text.substring(0, 3) + ") " + _newContactRegTextController.text.substring(3, 6) + "-" + _newContactRegTextController.text.substring(6, _newContactRegTextController.text.length);

    setState(() {
      _newContactRegTextController.text = '+63 ' + formattedPhoneNumber;
      edited = '+63 ' + formattedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
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
                            padding: const EdgeInsets.only(top: 130.0, left: 180),
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
                                  child: Center(
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                                            ],
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
                              padding: const EdgeInsets.only(top: 140.0, left: 40),
                              child: Text('You already have a verified \nphone number. \nDo you want to replace it?', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 14)),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 300),
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
                                                child: AutoSizeText('*For you to replace the old verified number. You should enter your old and new phone number here:', style: TextStyle(color: Colors.red, fontFamily: 'Nunito-Regular', fontSize: 15)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 28.0, right: 27, bottom: 10),
                                                child: AutoSizeText('Your old verified phone number is: ', style: TextStyle(color: Colors.green, fontFamily: 'Nunito-Regular', fontSize: 15)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 28.0, right: 27, bottom: 10),
                                                child: AutoSizeText(showOldVerifiedPhone, style: TextStyle(color: Colors.green, fontFamily: 'Nunito-Regular', fontSize: 15)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 30.0, left: 30, top: 10, bottom: 10),
                                                child: Container(
                                                  width: 480,
                                                  child: Column(
                                                    children: [
                                                      Focus(
                                                        child: TextField(
                                                          keyboardType: TextInputType.phone,
                                                          maxLength: 11,
                                                          controller: _oldContactRegTextController,
                                                          maxLengthEnforced: true,
                                                          inputFormatters: [
                                                            new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                          ],
                                                          decoration: InputDecoration(
                                                              labelText: 'Old Phone Number',
                                                              counterText: '',
                                                              isDense: true,
                                                              prefixIcon: IconButton(
                                                                color: Color(0xff085078),
                                                                icon: Icon(Icons.contact_page),
                                                                iconSize: 20.0,
                                                                onPressed: () {},
                                                              ),
                                                              contentPadding: EdgeInsets.only(left: 25.0),
                                                              hintText: 'Old Phone number',
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                                                        ),
                                                        onFocusChange: (hasFocus) {
                                                          // _oldContactRegTextController.text = '';

                                                          if (!hasFocus) {
                                                            // do stuff
                                                            setup1();
                                                          }
                                                        },
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
                                                          controller: _newContactRegTextController,
                                                          maxLengthEnforced: true,
                                                          inputFormatters: [
                                                            new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                          ],
                                                          decoration: InputDecoration(
                                                              labelText: 'New Phone Number',
                                                              counterText: '',
                                                              isDense: true,
                                                              prefixIcon: IconButton(
                                                                color: Color(0xff085078),
                                                                icon: Icon(Icons.contact_page),
                                                                iconSize: 20.0,
                                                                onPressed: () {},
                                                              ),
                                                              contentPadding: EdgeInsets.only(left: 25.0),
                                                              hintText: 'New Phone number',
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                                                        ),
                                                        onFocusChange: (hasFocus) {
                                                          // _newContactRegTextController.text = '';
                                                          if (!hasFocus) {
                                                            // do stuff
                                                            setup2();
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
                                                            child: Text('Send OTP', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                                            controller: _btnController,
                                                            onPressed: () {
                                                              if (_oldContactRegTextController.text.isEmpty || _newContactRegTextController.text.isEmpty) {
                                                                _showErrorAlert(title: "Verification failed.", content: 'All fields required.', onPressed: _changeBlackVisible, context: context);
                                                                _btnController.reset();
                                                              } else if (rawOldVerifiedPhone == oldVerifiedPhone) {
                                                                print('goodes.');
                                                                setState(() {
                                                                  _showSuccessAlert(title: "OTP CODE", content: "OTP SENT.", onPressed: _changeBlackVisible, context: context);

                                                                  Timer(Duration(seconds: 3), () {
                                                                    verifyPhone(rawNewVerifiedPhone);
                                                                    _btnController.reset();
                                                                  });
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                });
                                                              } else if (rawOldVerifiedPhone != oldVerifiedPhone) {
                                                                print('noopes');
                                                                _showErrorAlert(
                                                                    title: "Verification failed.",
                                                                    content: 'Entered old phone number is not the\n same as the on the database.', //show error firebase
                                                                    onPressed: _changeBlackVisible,
                                                                    context: context);
                                                                _btnController.reset();
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
                      )),
          ),
        ],
      ),
    );
  }

  signIn() async {
    String errorMessage;
    var usercheck;
    var collectionid2 = uuid.v1();
    var activity = 'Phone number verified.';
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    auth.currentUser.updatePhoneNumber(credential).then((user) async {
      var useruid;
      useruid = auth.currentUser.uid.toString();
      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: useruid).get();
      username.docs.forEach((document) {
        usercheck = document.data()['fullName'];
      });
      print(useruid);
      FirebaseFirestore.instance.collection("userlevel").doc(useruid.toString()).update({
        'isphoneverified': true,
        'phonenumber': edited,
        'rawphonenumber': rawNewVerifiedPhone,
        'timedate': Timestamp.now(),
      }).then((value) async {
        FirebaseFirestore.instance.collection("users").doc(useruid.toString()).update({
          'isphoneverified': true,
          "contact": edited,
          "contactraw": rawNewVerifiedPhone,
          'verifiedwhen': Timestamp.now(),
        });
      }).then((value) {
        FirebaseFirestore.instance.collection('usertrail').doc(useruid).set({
          // 'collectionid2': collectionid2,
          'lastactivity_datetime': Timestamp.now(),
        }).then((value) {
          FirebaseFirestore.instance.collection('usertrail').doc(useruid).collection('trail').doc(collectionid2).set({
            // 'collectionid2': collectionid2,
            'userid': useruid,
            'userfullname': usercheck,
            'this_collectionid': collectionid2,
            'activity': activity,
            'editcreate_datetime': Timestamp.now(),
            'editcreate_collectionid': useruid,
          });
        }).then((value) {
          Get.snackbar(
            "Success!",
            "Phone number Changed Successfully!",
            duration: Duration(seconds: 3),
          );
          Timer(Duration(seconds: 3), () {
            _btnController2.reset();
            // auth.signOut();
            if (widget.fromWhere == 'editUser') {
              Get.offAll(EditInfoState());
            } else {
              Get.offAll(EditInfo());
            }
          });
        });
      });
    }).catchError((e) {
      print(e.toString());
      switch (e.code) {
        case "unknown":
          errorMessage = "User has already been linked to the given provider.";
          _showErrorAlert(
              title: "Verification failed.",
              content: errorMessage, //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          _btnController2.reset();
          break;
        case "invalid-verification-code":
          errorMessage = " The sms verification code used to create the phone link credential is invalid.";
          _showErrorAlert(
              title: "Verification failed.",
              content: errorMessage, //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
          _btnController2.reset();
          break;
        default:
          errorMessage = "An undefined Error happened.";
          _btnController2.reset();
      }
    });
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
