import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/pages/forcamera/flagged.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class WithoutIdent extends StatefulWidget {
  @override
  _WithoutIdentState createState() => _WithoutIdentState();
}

class _WithoutIdentState extends State<WithoutIdent> {
  List<String> _checked2 = [];
  TextEditingController _notesTextController;
  RoundedLoadingButtonController _btnController;
  bool _blackVisible = false;
  TextEditingController _fnameRegTextController;
  TextEditingController _mnameRegTextController;
  bool fname = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool mname = false;
  bool notes = false;
  String post;
  String email;
  GlobalKey _toolTipKey = GlobalKey();
  var maskFormatter = new MaskTextInputFormatter(mask: 'A##-##-######');

  var maskFormatter3 = new MaskTextInputFormatter(
      mask: 'SS-SSSS', filter: {"S": RegExp(r'[AB]')});

  void _changeBlackVisible() {
    _blackVisible = !_blackVisible;
  }

  void _showErrorAlert(
      {String title,
      String content,
      VoidCallback onPressed,
      BuildContext context}) {
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

  getPost() async {
    User user = auth.currentUser;
    QuerySnapshot username = await FirebaseFirestore.instance
        .collection('users')
        .where('collectionId', isEqualTo: user.uid.toString())
        .get();
    username.docs.forEach((document) {
      email = document.data()['email'];
    });
    setState(() {
      check();
    });
  }

  check() async {
    QuerySnapshot usernamex = await FirebaseFirestore.instance
        .collection('userlevel')
        .where('email', isEqualTo: email)
        .get();
    usernamex.docs.forEach((document) {
      post = document.data()['level'];
    });
    setState(() {
      print(email + post);
    });
  }

  @override
  void initState() {
    _notesTextController = TextEditingController();
    _fnameRegTextController = TextEditingController();
    _mnameRegTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    // fname = false;
    // mname = false;
    _checked2 = [];
    notes = true;
    getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff085078),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.of(context).popUntil((_) => count++ >= 2)),
        title: Text(
          "Without Identification",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 50, bottom: 30),
              child: Container(
                width: Get.width,
                height: 800,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.40),
                        blurRadius: 30,
                        spreadRadius: 1)
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, bottom: 0),
                          child: Row(
                            children: [
                              Text(
                                "Flag Via:",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 30.0,
                                  fontFamily: 'Nunito-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final dynamic tooltip =
                                      _toolTipKey.currentState;
                                  tooltip.ensureTooltipVisible();
                                },
                                child: Tooltip(
                                  key: _toolTipKey,
                                  // ignore: missing_required_param
                                  child: IconButton(
                                    icon: Icon(Icons.info, size: 20.0, color: Colors.red),
                                  ),
                                  message:
                                      'If a Driver failed to show any identifcations or does not have any license plate installed then:\nIt is time for human interaction, and should be personally questioned.',
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.all(20),
                                  showDuration: Duration(seconds: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.9),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
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

                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 40),
                      child: Row(
                        children: [
                          Text(
                            "Selections: ",
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
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                        child: CheckboxGroup(
                          margin: const EdgeInsets.only(left: 12.0),
                          labels: <String>[
                            "Drivers License",
                            "Conduction Sticker",
                          ],
                          onSelected: (checked) => setState(() {
                            if (checked.length > 1) {
                              checked.removeAt(0);
                              print(checked);

                              if (checked.contains('Drivers License')) {
                                setState(() {
                                  fname = true;
                                  mname = false;
                                  _checked2 = checked;
                                  notes = false;
                                  _mnameRegTextController.text = '';
                                  _fnameRegTextController.text = '';
                                  _notesTextController.text = '';
                                });
                              } else {
                                fname = false;
                              }

                              if (checked.contains('Conduction Sticker')) {
                                setState(() {
                                  fname = false;
                                  mname = true;
                                  _checked2 = checked;
                                  notes = false;
                                  _mnameRegTextController.text = '';
                                  _fnameRegTextController.text = '';
                                  _notesTextController.text = '';
                                });
                              } else {
                                mname = false;
                              }
                            } else {
                              print(checked);
                              if (checked.contains('Drivers License')) {
                                setState(() {
                                  fname = true;
                                  mname = false;
                                  notes = false;
                                  _checked2 = checked;
                                  _mnameRegTextController.text = '';
                                  _fnameRegTextController.text = '';
                                  _notesTextController.text = '';
                                  notes = false;
                                });
                              } else {
                                fname = false;
                              }
                              if (checked.contains('Conduction Sticker')) {
                                setState(() {
                                  fname = false;
                                  mname = true;
                                  _checked2 = checked;
                                  notes = false;
                                  _mnameRegTextController.text = '';
                                  _fnameRegTextController.text = '';
                                  _notesTextController.text = '';
                                });
                              } else {
                                mname = false;
                              }
                            }

                            if (checked.length == 0) {
                              notes = true;
                            }
                          }),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, left: 12, top: 10, bottom: 12),
                      child: Container(
                        width: 480,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, top: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "If Drivers license: ",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              maxLength: 50,
                              controller: _fnameRegTextController,
                              enabled: fname ? true : false,

                              // textCapitalization: TextCapitalization.words,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [maskFormatter],
                              decoration: InputDecoration(
                                  counterText: '',
                                  isDense: true,
                                  prefixIcon: IconButton(
                                    color: Color(0xff085078),
                                    icon: Icon(Icons.perm_identity),
                                    iconSize: 20.0,
                                    onPressed: () {},
                                  ),
                                  contentPadding: EdgeInsets.only(left: 25.0),
                                  hintText: 'A00-00-000000',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0))),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          right: 12.0, left: 12, top: 10, bottom: 12),
                      child: Container(
                        width: Get.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0, top: 0),
                              child: Row(
                                children: [
                                  Text(
                                    "If Conduction sticker:",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15.0,
                                      fontFamily: 'Nunito-Bold',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Focus(
                              child: TextField(
                                enabled: mname ? true : false,
                                maxLength: 6,
                                onChanged: (String value) async {
                                  // if (value != '') {
                                  //   if (value.length > 4) {
                                  //     String hello = value.substring(0, 2);
                                  //     String rest = value.substring(2, 6);
                                  //     print(hello);
                                  //     print(rest);
                                  //     setState(() {
                                  //       // value = hello + '-' + rest;

                                  //       _mnameRegTextController.text = hello +  '-' + rest;
                                  //     });
                                  //   }
                                  // }
                                  // if (value != '') {
                                  //   inputEmail();
                                  // }
                                  // String hello = value.substring(0,2);
                                  // String rest = value.substring(3,7);
                                  // setState(() {
                                  //   value = hello + '-' + rest;
                                  // });
                                },
                                controller: _mnameRegTextController,
                                // textCapitalization: TextCapitalization.words,
                                // inputFormatters: [maskFormatter3],
                                textCapitalization:
                                    TextCapitalization.characters,

                                decoration: InputDecoration(
                                    counterText: '',
                                    isDense: true,
                                    prefixIcon: IconButton(
                                      color: Color(0xff085078),
                                      icon: Icon(Icons.perm_identity),
                                      iconSize: 20.0,
                                      onPressed: () {},
                                    ),
                                    contentPadding: EdgeInsets.only(left: 25.0),
                                    hintText: 'SS-SSSS',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0))),
                              ),
                              onFocusChange: (hasFocus) {
                                if (!hasFocus) {
                                  String value = _mnameRegTextController.text;
                                  String hello = value.substring(0, 2);
                                  String rest = value.substring(2, 6);
                                  print(hello);
                                  print(rest);
                                  setState(() {
                                    // value = hello + '-' + rest;

                                    _mnameRegTextController.text =
                                        hello + '-' + rest;
                                    _mnameRegTextController.text =
                                        _mnameRegTextController.text
                                            .toUpperCase();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Container(
                    //   width: 330.0,
                    //   height: 200,
                    //   child: Column(
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //             top: 20.0, left: 10, right: 0, bottom: 0),
                    //         child: Row(
                    //           children: [
                    //             Text(
                    //               "Other Identification/s:",
                    //               style: TextStyle(
                    //                 color: Colors.red,
                    //                 fontSize: 20.0,
                    //                 fontFamily: 'Nunito-Bold',
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       new Expanded(
                    //           child: Padding(
                    //         padding: const EdgeInsets.only(
                    //             left: 15.0, right: 15, bottom: 20),
                    //         child: TextField(
                    //            textCapitalization:
                    //                 TextCapitalization.sentences,
                    //           controller: _notesTextController,
                    //           enabled: notes ? true : false,
                    //           maxLines: null,
                    //           expands: true,
                    //           keyboardType: TextInputType.multiline,
                    //           decoration:
                    //               InputDecoration(hintText: "Tap to write..."),
                    //         ),
                    //       )),
                    //     ],
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 80.0, right: 0, left: 5, bottom: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundedLoadingButton(
                                color: Color(0xff085078),
                                child: Text('Next',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nunito-Regular',
                                        fontSize: 18)),
                                controller: _btnController,
                                onPressed: () async {
                                  print(_checked2.toString());
                                  if (_checked2.isEmpty == true) {
                                    setState(() {
                                      _btnController.reset();
                                    });

                                    _showErrorAlert(
                                        title: "FLAGGING FAILED",
                                        content:
                                            "Please choose/write a valid reason.",
                                        onPressed: _changeBlackVisible,
                                        context: context);
                                    _btnController.reset();
                                  } else {
                                    // showAlertDialog(context);
                                    if (_checked2.contains('Drivers License') &&
                                        _fnameRegTextController.text == '') {
                                      _showErrorAlert(
                                          title: "FLAGGING FAILED",
                                          content:
                                              "Please choose/write a valid reason.",
                                          onPressed: _changeBlackVisible,
                                          context: context);
                                      _btnController.reset();
                                    } else if (_checked2
                                            .contains('Conduction Sticker') &&
                                        _mnameRegTextController.text == '') {
                                      _showErrorAlert(
                                          title: "FLAGGING FAILED",
                                          content:
                                              "Please choose/write a valid reason.",
                                          onPressed: _changeBlackVisible,
                                          context: context);
                                      _btnController.reset();
                                    } else if (_checked2.length <= 0 &&
                                        _notesTextController.text == '') {
                                      _showErrorAlert(
                                          title: "FLAGGING FAILED",
                                          content:
                                              "Please choose/write a valid reason.",
                                          onPressed: _changeBlackVisible,
                                          context: context);
                                      _btnController.reset();
                                    } else {
                                      print('okay');

                                      if (_checked2
                                          .contains('Drivers License')) {
                                        Get.offAll(Flagged(
                                          vehicle: _fnameRegTextController.text,
                                          wherefrom: post,
                                        ));
                                      }
                                      if (_checked2
                                          .contains('Conduction Sticker')) {
                                        Get.offAll(Flagged(
                                          vehicle: _mnameRegTextController.text,
                                          wherefrom: post,
                                        ));
                                      }
                                    }
                                  }
                                  //  if (_checked2.length == 0 && _notesTextController.text != '') {
                                  //       Get.offAll(Flagged(
                                  //         vehicle: _notesTextController.text,
                                  //         wherefrom: post,
                                  //       ));
                                  //     }

                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
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
    );
  }
}
