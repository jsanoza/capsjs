import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:get_rekk/helpers/navbuttonusers.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../changephonenumber.dart';
import '../loginsignup.dart';
import '../phoneverification.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  GlobalKey _toolTipKey2 = GlobalKey();
  TextEditingController _rePasswordTextController;
  TextEditingController _frstPasswordTextController;
  TextEditingController _oldPasswordTextController;
  TextEditingController _contactRegTextController;
  RoundedLoadingButtonController _btnController;
  RoundedLoadingButtonController _btnController1;
  String finalpassword;
  bool isVerified = false;
  bool checkCurrentPasswordValid = true;
  List<double> limits = [];
  List<String> indexList2 = [];
  File _image;
  final picker = ImagePicker();
  GlobalKey _toolTipKey = GlobalKey();
  GlobalKey _toolTipKey4 = GlobalKey();
  GlobalKey _toolTipKey3 = GlobalKey();
  bool isMenuOpen = false;
  bool isShown = false;
  bool _blackVisible = false;
  bool _obscureText3 = true;
  bool _obscureText2 = true;
  bool _obscureText1 = true;
  bool _passError = false;
  bool _passError2 = false;
  bool allGoods = false;
  var uuid = Uuid();
  FirebaseAuth auth = FirebaseAuth.instance;
  String post;
  String oldContact;
  @override
  void initState() {
    _rePasswordTextController = TextEditingController();
    _frstPasswordTextController = TextEditingController();
    _oldPasswordTextController = TextEditingController();
    _contactRegTextController = TextEditingController();

    // inputData();
    limits = [0, 0, 0, 0, 0, 0];
    _btnController = RoundedLoadingButtonController();
    _btnController1 = RoundedLoadingButtonController();
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

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

  showAlertDialog2(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        _btnController.reset();
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // sendReqChange();
        // check(dropdownValue);
        // uploadPic();
        changePass();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        '''
Confirm Change Password?

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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        _btnController.reset();
        Get.back();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        // sendReqChange();
        // check(dropdownValue);
        uploadPic();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text(
        '''
Confirm editing your user info?

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

  void _changeBlackVisible() {
    _blackVisible = !_blackVisible;
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

  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
    String hello;
    return hello;
  }

  // void inputData() async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   print(uid);
  //   // here you write the codes to input the data into firestore
  // }

  Future<String> uploadImage(File image) async {
    String unique = uuid.v1();
    User user = auth.currentUser;
    // final userid = widget.user.uid;
    Reference storageRef = FirebaseStorage.instance.ref().child('ppic').child(user.uid.toString());
    await storageRef.putFile(_image);
    return await storageRef.getDownloadURL();
  }

  Future uploadPic() async {
    // String notes = _notesTextController.text;
    User user = auth.currentUser;

    var now2 = new DateTime.now();
    var dateLocal = now2.toLocal();
    var formatter2 = new DateFormat('MM/dd/yyyy hh:mm:ss');
    String formatted2 = formatter2.format(dateLocal);
    var collectionid2 = uuid.v1();
    var currentUser = user.uid;
    var usercheck;
    var activity = 'Updated profile.';
    SharedPreferences ppUrlSP = await SharedPreferences.getInstance();
    FocusScope.of(context).requestFocus(new FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      // if (_contactRegTextController.text.isEmpty) {
      //   _contactRegTextController.text = oldContact.toString();
      // }
      // String unique2 = uuid.v1();
      var dUrl = await uploadImage(_image);

      QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
      username.docs.forEach((document) {
        usercheck = document.data()['fullName'];
      });

      FirebaseFirestore.instance.collection("users").doc(user.uid.toString()).update({
        "picUrl": dUrl.toString(),
        // "contact": _contactRegTextController.text.isEmpty ? oldContact.toString() : _contactRegTextController.text.toString(),
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
          'editcreate_collectionid': user.uid,
        });
      });

      await ppUrlSP.setString('ppUrlSP', dUrl.toString());
      print("im here");
      _showSuccessAlert(
          title: "Congrats!",
          content: "Upload Info Successful!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      setState(() {
        _btnController.reset();
        _contactRegTextController.clear();
        _image = null;

        UserLog.ppUrl = dUrl.toString();
        // Navigator.pop(context);
      });
    } catch (e) {
      _showErrorAlert(
          title: "Editing info failed.",
          content: "Editing failed!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
    }
  }

  Future<bool> validatePassword(String password) async {
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
    return await validatePassword(password);
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = auth.currentUser;
    firebaseUser.updatePassword(password);
  }

  Future changePass() async {
    checkCurrentPasswordValid = await validateCurrentPassword(_oldPasswordTextController.text);
    _btnController1.reset();
    var collectionid2 = uuid.v1();
    User user = auth.currentUser;
    var currentUser = user.uid;
    var usercheck;
    var activity = 'Changed Password.';
    if (checkCurrentPasswordValid == true) {
      print(checkCurrentPasswordValid);
      if (_rePasswordTextController.text.isNotEmpty && _frstPasswordTextController.text.isNotEmpty) {
        if (_rePasswordTextController.text == _frstPasswordTextController.text) {
          try {
            QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
            username.docs.forEach((document) {
              usercheck = document.data()['fullName'];
            });

            updatePassword(_rePasswordTextController.text.toString());

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
            });
            _showSuccessAlert(
                title: "Congrats!",
                content: "Change Password Successful!", //show error firebase
                onPressed: _changeBlackVisible,
                context: context);
            setState(() {
              _btnController.reset();
              _frstPasswordTextController.clear();
              _rePasswordTextController.clear();
              _oldPasswordTextController.clear();
              _contactRegTextController.clear();

              // Navigator.pop(context);
            });
          } catch (e) {
            _showErrorAlert(
                title: "Password Update Failed.",
                content: "Password Update failed!", //show error firebase
                onPressed: _changeBlackVisible,
                context: context);
          }
        } else {
          _showErrorAlert(
              title: "Password Update Failed.",
              content: "Password fields are not the same!", //show error firebase
              onPressed: _changeBlackVisible,
              context: context);
        }
      } else {
        _showErrorAlert(
            title: "Password Update Failed.",
            content: "Password field is empty!", //show error firebase
            onPressed: _changeBlackVisible,
            context: context);
      }
    } else {
      _showErrorAlert(
          title: "Password Update Failed.",
          content: "Old password is wrong!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
    }
  }

  getShop2() {
    User user = auth.currentUser;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("users").where('collectionId', isEqualTo: user.uid.toString()).snapshots();
    return qn;
  }

  _buildMain2() {
    return Container(
      width: Get.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: getShop2(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Text('');
            } else {
              if (snapshot.data == null) {
                return Text('');
              } else {
                if (snapshot.data.docs[0]['position'].toString() == 'Leader') {
                  post = 'Team Leader';
                  oldContact = snapshot.data.docs[0]['contact'].toString();
                } else {
                  post = snapshot.data.docs[0]['position'].toString();
                  oldContact = snapshot.data.docs[0]['contact'].toString();
                }
                isVerified = snapshot.data.docs[0]['isphoneverified'];
                return Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, right: 0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  Positioned(
                                    top: 90,
                                    right: 10,
                                    child: new Container(
                                      width: 100.00,
                                      height: 100.00,
                                      child: Image.network(
                                        snapshot.data.docs[0]['picUrl'],
                                        // 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
                                        // posts[index].dUrl,
                                        height: MediaQuery.of(context).size.height * 0.35,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 20, bottom: 20),
                                    child: AutoSizeText(
                                      snapshot.data.docs[0]['rank'] + ' ' + snapshot.data.docs[0]['fullName'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50.0, left: 20),
                                    child: Text(
                                      "Badge Number:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 75.0,
                                      left: 20,
                                    ),
                                    child: Text(
                                      snapshot.data.docs[0]['badgeNum'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 110.0, left: 20),
                                    child: Text(
                                      "Rank:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 135.0, left: 20),
                                    child: Text(
                                      snapshot.data.docs[0]['rank'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 170.0, left: 20),
                                    child: Text(
                                      "Position:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 195.0,
                                      left: 20,
                                      bottom: 50,
                                    ),
                                    child: Text(
                                      post,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 230.0, left: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Contact Number:",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontFamily: 'Nunito-Bold',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 250.0, left: 20),
                                    child: Row(
                                      children: [
                                        isVerified
                                            ? GestureDetector(
                                                onTap: () {
                                                  final dynamic tooltip = _toolTipKey.currentState;
                                                  tooltip.ensureTooltipVisible();
                                                },
                                                child: Tooltip(
                                                  key: _toolTipKey,
                                                  // ignore: missing_required_param
                                                  child: IconButton(
                                                    icon: Icon(Icons.verified, size: 30.0, color: Colors.green),
                                                  ),
                                                  message: 'Phone number is verified!',
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
                                            : GestureDetector(
                                                onTap: () {
                                                  final dynamic tooltip = _toolTipKey.currentState;
                                                  tooltip.ensureTooltipVisible();
                                                },
                                                child: Tooltip(
                                                  key: _toolTipKey,
                                                  // ignore: missing_required_param
                                                  child: IconButton(
                                                    icon: Icon(Icons.error_outline, size: 30.0, color: Colors.red),
                                                  ),
                                                  message: 'Phone number is not verified!',
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0.0),
                                          child: Text(
                                            snapshot.data.docs[0]['contact'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontFamily: 'Nunito-Bold',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit, size: 25.0, color: Colors.red),
                                          onPressed: () {
                                            if (isVerified = true) {
                                              Get.to(ChangePhone(
                                                isVerified: isVerified,
                                                fromWhere: 'editAdmin',
                                              ));
                                            } else {
                                              Get.to(
                                                Phone(
                                                  isVerified: isVerified,
                                                  fromWhere: 'editAdmin',
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }
          }),
    );
  }

  _buildMain3() {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 10),
                  child: Text(
                    "Upload Photo",
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
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, left: 20),
                          child: Text(
                            "Profile Photo",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: 150,
                                height: 150,
                                color: Colors.grey[300],
                                child: _image != null ? Image.file(_image, fit: BoxFit.cover) : Text('Please select an image'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff085078),
                          onPrimary: Colors.white,
                        ),
                        child: Text('Select An Image'),
                        onPressed: () async {
                          _openImagePicker();
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 12.0, left: 12, top: 10, bottom: 12),
                    //   child: Container(
                    //     width: 480,
                    //     child: Column(
                    //       children: [
                    //         TextField(
                    //           keyboardType: TextInputType.number,
                    //           maxLength: 11,
                    //           controller: _contactRegTextController,
                    //           decoration: InputDecoration(
                    //               counterText: '',
                    //               isDense: true,
                    //               prefixIcon: IconButton(
                    //                 color: Color(0xff085078),
                    //                 icon: Icon(Icons.contact_page),
                    //                 iconSize: 20.0,
                    //                 onPressed: () {},
                    //               ),
                    //               contentPadding: EdgeInsets.only(left: 25.0),
                    //               hintText: 'Contact Number',
                    //               border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 0, left: 0, bottom: 0),
                      child: Container(
                        width: Get.width,
                        // height: 200,
                        child: Column(
                          children: [
                            RoundedLoadingButton(
                              color: Color(0xff085078),
                              child: Text('Upload', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                              controller: _btnController,
                              onPressed: () {
                                //  sendData();
                                setState(() {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  showAlertDialog(context);
                                });
                              },
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
      ],
    );
  }

  _buildMain4() {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0, right: 8, left: 8, bottom: 30),
              child: Container(
                height: 500,
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
                          padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 10),
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 10),
                      child: Text('If you have not changed your default password, \nWe highly suggest you change it now.', style: TextStyle(color: Colors.red, fontFamily: 'Nunito-Regular', fontSize: 14)),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0, left: 0),
                    //   child: AutoSizeText('' + _emailRegTextControllerx1.text + '@acpsone.com', style: TextStyle(color: Colors.red, fontFamily: 'Nunito-Regular', fontSize: 20)),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 480,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0, left: 20, top: 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Enter Old Password:",
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
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.blue),
                                      ),
                                      message: 'Please enter your old password',
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
                                      maxLength: 15,
                                      obscureText: _obscureText1,
                                      controller: _oldPasswordTextController,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        isDense: true,
                                        labelText: 'Old Password',
                                        prefixIcon: Icon(
                                          Icons.lock_outline_sharp,
                                          color: Color(0xff085078),
                                        ),
                                        contentPadding: EdgeInsets.only(left: 25.0),
                                        hintText: "Old Password",
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            _oldpretoggle();
                                          },
                                          child: Icon(_obscureText1 ? Icons.visibility_off : Icons.visibility),
                                        ),
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
                                      final dynamic tooltip = _toolTipKey3.currentState;
                                      tooltip.ensureTooltipVisible();
                                    },
                                    child: Tooltip(
                                      key: _toolTipKey3,
                                      // ignore: missing_required_param
                                      child: IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.blue),
                                      ),
                                      message: 'Common Allowed Characters (!@#*~)\n'
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
                                      final dynamic tooltip = _toolTipKey4.currentState;
                                      tooltip.ensureTooltipVisible();
                                    },
                                    child: Tooltip(
                                      key: _toolTipKey4,
                                      // ignore: missing_required_param
                                      child: IconButton(
                                        icon: Icon(Icons.info, size: 20.0, color: Colors.blue),
                                      ),
                                      message: 'Common Allowed Characters (!@#*~)\n'
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
                                                // finalemail = _emailRegTextControllerx1.text + '@acpsone.com';
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
                                width: Get.width,
                                child: Column(
                                  children: [
                                    RoundedLoadingButton(
                                      color: Color(0xff085078),
                                      child: Text('Change Password', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                      controller: _btnController1,
                                      onPressed: () {
                                        if (allGoods == true && _oldPasswordTextController.text.length > 8) {
                                          setState(() {
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                                            // showAlertDialog(context);
                                            // _btnController3.reset();
                                            showAlertDialog2(context);
                                            // changePass();
                                          });
                                        } else {
                                          _showErrorAlert(
                                              title: "Change Password failed.",
                                              content: "Invalid inputs", //show error firebase
                                              onPressed: _changeBlackVisible,
                                              context: context);
                                          _btnController1.reset();
                                        }
                                      },
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
      ],
    );
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
              width: Get.width,
              decoration: BoxDecoration(),
              child: Stack(
                children: <Widget>[
                  CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Color(0xff085078),
                        floating: true,
                        pinned: true,
                        snap: true,
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
                                      "Edit Info",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: AvatarGlow(
                                      startDelay: Duration(milliseconds: 0),
                                      glowColor: Colors.red,
                                      endRadius: 40.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 0),
                                      child: IconButton(
                                        iconSize: 25.0,
                                        icon: Icon(Icons.menu),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            isMenuOpen = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            background: Image.network(
                              'https://www.racq.com.au/-/media/racqgroupmvc/feature/live/news/crashes/police-crash.jpg?h=623&w=935&rev=42f176f3bbfd46899f3acf31591ae87f&hash=8272D24DD8207FF2030977B0B55276750FB3E301',
                              fit: BoxFit.cover,
                            )),
                        expandedHeight: 200,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int pdIndex) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20, bottom: 20),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: new BorderRadius.circular(10.0),
                                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                            ),
                                            child: _buildMain2()),
                                      ],
                                    ),
                                  ),
                                  //... The children inside the column of ListView.
                                  new Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0, bottom: 20),
                                        child: Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: new BorderRadius.circular(10.0),
                                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                            ),
                                            child: _buildMain3()),
                                      ),
                                    ],
                                  ),

                                  new Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 0, bottom: 20),
                                        child: _buildMain4(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          // Builds 1000 ListTiles
                          childCount: 1,
                        ),
                      )
                    ],
                  ),

                  //here starts of the animation and navigation bar
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1500),
                    left: isMenuOpen ? 0 : -sidebarSize + 1,
                    top: 0,
                    curve: Curves.elasticOut,
                    child: SizedBox(
                      width: sidebarSize,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          if (details.localPosition.dx <= sidebarSize) {
                            setState(() {
                              _offset = details.localPosition;
                            });
                          }

                          if (details.localPosition.dx > sidebarSize - 20 && details.delta.distanceSquared > 2) {
                            setState(() {
                              isMenuOpen = true;
                            });
                          }
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _offset = Offset(0, 0);
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            CustomPaint(
                              size: Size(sidebarSize, Get.height),
                              painter: DrawerPainter2(offset: _offset),
                            ),
                            Container(
                              height: Get.height,
                              width: sidebarSize,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: Get.height * 0.30,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 120,
                                            width: 120,
                                            // padding: EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(UserLog.ppUrl),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 28.0),
                                            child: Text(
                                              UserLog.rank + '. ' + UserLog.fullName.toUpperCase(),
                                              style: TextStyle(color: Colors.black45),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  Container(
                                    key: globalKey,
                                    width: double.infinity,
                                    height: menuContainerHeight,
                                    child: Column(
                                      children: <Widget>[
                                        MyButton(text: "Add Schedule", iconData: Icons.library_add_check, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 1),
                                        // MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 4),
                                        // MyButton(text: "Edit Info", iconData: Icons.app_registration, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 2),
                                        // MyButton(text: "Reset Users Password", iconData: Icons.replay, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 3),
                                        MyButton(text: "Vehicles", iconData: Icons.local_car_wash, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 5),
                                        MyButton(text: "Manage Users", iconData: Icons.settings_applications, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 3),

                                        // MyButton2(text: "OCR", iconData: Icons.camera, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 2),
                                        // MyButton2(text: "OCR TRY", iconData: Icons.camera, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                        // MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        auth.signOut();
                                        Get.offAll(LogSign());
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Color(0xff085078),
                                            size: 25.0,
                                          ),
                                          Text(
                                            '  Logout',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Nunito-Bold'),
                                          ),
                                        ],
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
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
