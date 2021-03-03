import 'dart:async';
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_dialog.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../loginsignup.dart';

class VehicleList extends StatefulWidget {
  @override
  _VehicleList createState() => _VehicleList();
}

//TO DO save to DB who ever did the changes
class _VehicleList extends State<VehicleList> {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  TextEditingController _emailTextController;
  RoundedLoadingButtonController _btnController;
  TextEditingController _vehiclekindTextController;
  TextEditingController _vehicleplateTextController;
  TextEditingController _vehiclebrandTextController;
  TextEditingController _vehiclemodelTextController;
  TextEditingController _vehicledescTextController;
  TextEditingController _vehiclereasTextController;

  List<double> limits = [];
  List<String> indexList2 = [];
  String dropdownValue;
  String searchString;
  String uid;
  bool isMenuOpen = false;
  bool isShown = false;
  bool _blackVisible = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isEdited = false;
  String query;
  String todeleteveh;
  var uuid = Uuid();

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    _vehicledescTextController = TextEditingController();
    _vehiclemodelTextController = TextEditingController();
    _vehiclebrandTextController = TextEditingController();
    _vehicleplateTextController = TextEditingController();
    _vehiclekindTextController = TextEditingController();
    _btnController = RoundedLoadingButtonController();
    _vehiclereasTextController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    _emailTextController = TextEditingController();
    isShown = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

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
    double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 15 : 12;
    return size;
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

  getHolder() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("vehicles").snapshots();
    return qn;
  }

  _buildMain2() {
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 5, bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Vehicle List",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
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
                                  _showAdd(context);
                                  // _showModalSheet();
                                  // _onTap();
                                  // handleSignIn();
                                }, //only after checking
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
                  // _secondShow ? _showSearchList() : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 480,
                child: Column(
                  children: [
                    Container(
                      height: 400,
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
                                      confirmDismiss: (DismissDirection direction) async {
                                        if (direction == DismissDirection.startToEnd) {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Delete Confirmation"),
                                                content: const Text("Are you sure you want to delete this item?"),
                                                actions: <Widget>[
                                                  FlatButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete")),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Edit Confirmation"),
                                                content: const Text("Are you sure you want to edit this item?"),
                                                actions: <Widget>[
                                                  FlatButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Edit")),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      onDismissed: (DismissDirection direction) async {
                                        if (direction == DismissDirection.startToEnd) {
                                          var hotcar = snapshot.data.docs[index]['query'].toString();
                                          var activity = 'Deleted a hot-car with plate number: $hotcar';
                                          User user = auth.currentUser;
                                          var currentUser = user.uid;
                                          var usercheck;
                                          var collectionid2 = uuid.v1();

                                          QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
                                          username.docs.forEach((document) {
                                            usercheck = document.data()['fullName'];
                                          });

                                          FirebaseFirestore.instance.collection("vehicles").doc(snapshot.data.docs[index]['query'].toString()).delete().then((value) {
                                            print('deleted');
                                          });

                                          FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
                                            // 'collectionid2': collectionid2,
                                            'lastactivity.datetime': Timestamp.now(),
                                          }).then((value) {
                                            FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
                                              // 'collectionid2': collectionid2,
                                              'userid': user.uid,
                                              'userfullname': usercheck,
                                              'this.collectionid': collectionid2,
                                              'activity': activity,
                                              'editcreate.datetime': Timestamp.now(),
                                              'editcreate.collectionid': snapshot.data.docs[index]['query'].toString(),
                                            });
                                          });

                                          setState(
                                            () {
                                              print('left');
                                            },
                                          );
                                        } else {
                                          // FirebaseFirestore.instance.collection("trialvehicles").doc(snapshot.data.docs[index]['plate'].toString()).delete().then((value) {
                                          //   vehiclelist.remove(snapshot.data.docs[index]['plate'].toString());
                                          //   print('deleted');
                                          //   print(vehiclelist);
                                          // });

                                          QuerySnapshot snap = await FirebaseFirestore.instance.collection('vehicles').where("vehicle", isEqualTo: snapshot.data.docs[index]['query']).get();
                                          snap.docs.forEach((document) {
                                            FirebaseFirestore.instance.collection("vehicles").doc(snapshot.data.docs[index]['query'].toString()).collection("editedVehicle").doc(snapshot.data.docs[index]['vehicle']).set({
                                              'vehicle': document.data()['vehicle'],
                                              'vehiclebrand': document.data()['vehiclebrand'],
                                              'vehicledesc': document.data()['vehicledesc'],
                                              'vehiclekind': document.data()['vehiclekind'],
                                              'vehiclemodel': document.data()['vehiclemodel'],
                                              'reason': document.data()['reason'],
                                              'addedby': document.data()['addedby'],
                                              'addedtime': document.data()['addedtime'],
                                            });
                                          });

                                          setState(
                                            () {
                                              isEdited = true;
                                              print('right');
                                              _showAdd(context);
                                              query = snapshot.data.docs[index]['query'].toString();
                                              todeleteveh = snapshot.data.docs[index]['vehicle'].toString();
                                              _vehiclekindTextController.text = snapshot.data.docs[index]['vehiclekind'].toString();
                                              _vehicleplateTextController.text = snapshot.data.docs[index]['vehicle'].toString();
                                              _vehiclebrandTextController.text = snapshot.data.docs[index]['vehiclebrand'].toString();
                                              _vehiclemodelTextController.text = snapshot.data.docs[index]['vehiclemodel'].toString();
                                              _vehicledescTextController.text = snapshot.data.docs[index]['vehicledesc'].toString();
                                              _vehiclereasTextController.text = snapshot.data.docs[index]['reason'].toString();
                                            },
                                          );
                                        }
                                        setState(() {
                                          // if (userSearchBlockName.isEmpty) {
                                          //   _fourthShow = false;
                                          // }
                                        });
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
                                                leading: Container(padding: EdgeInsets.all(8.0), child: Text(snapshot.data.docs[index]['vehicle'])
                                                    // CircleAvatar(
                                                    //   backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                                    // ),
                                                    ),
                                                title: Text(snapshot.data.docs[index]["vehiclebrand"]),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 0.0),
                                                        child: Text(
                                                          snapshot.data.docs[index]["vehiclemodel"],
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
            ),
          ],
        ),
      ],
    );
  }

  _showAdd(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (builder) {
        return SafeArea(
          left: true,
          top: true,
          right: true,
          bottom: true,
          minimum: const EdgeInsets.only(top: 25.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                      color: Colors.white,
                      onPressed: () async {
                        FirebaseFirestore.instance.collection("vehicles").doc(query).collection("editedVehicle").doc(todeleteveh).delete();

                        Get.offAll(VehicleList());
                      }),
                  title: Text("Add Vehicle", style: TextStyle(color: Colors.white)),
                  backgroundColor: Color(0xff1D976C),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    height: 1000,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 20.0),
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
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 20),
                              child: Text(
                                "Kind of Vehicle",
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
                                  color: Colors.green,
                                  icon: Icon(Icons.style),
                                  iconSize: 20.0,
                                  onPressed: () {},
                                ),
                                contentPadding: EdgeInsets.only(left: 25.0),
                                hintText: 'Vehicle Kind',
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
                            maxLength: 50,
                            controller: _vehicleplateTextController,
                            inputFormatters: [
                              new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9]")),
                            ],
                            decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                prefixIcon: IconButton(
                                  color: Colors.green,
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
                                  color: Colors.green,
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
                                  color: Colors.green,
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
                              height: 100,
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
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0, left: 20, right: 0, bottom: 0),
                              child: Row(
                                children: [
                                  Text(
                                    "Reason",
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
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 20),
                                child: TextField(
                                  controller: _vehiclereasTextController,
                                  maxLines: null,
                                  expands: true,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(hintText: "Tap to write..."),
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
                                        color: Color(0xff1D976C),
                                        child: Text('Add', style: TextStyle(color: Colors.white, fontFamily: 'Nunito-Regular', fontSize: 18)),
                                        controller: _btnController,
                                        onPressed: () async {
                                          String vkind = _vehiclekindTextController.text;
                                          String vplate = _vehicleplateTextController.text;
                                          String vbrand = _vehiclebrandTextController.text;
                                          String vmodel = _vehiclemodelTextController.text;
                                          String vdesc = _vehicledescTextController.text;
                                          String vreas = _vehiclereasTextController.text;

                                          try {
                                            if (isEdited == true) {
                                              var activity = 'Edited a hot-car with plate number: $vplate';

                                              User user = auth.currentUser;
                                              var currentUser = user.uid;
                                              var usercheck;
                                              var collectionid2 = uuid.v1();

                                              QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
                                              username.docs.forEach((document) {
                                                usercheck = document.data()['fullName'];
                                              });

                                              FirebaseFirestore.instance.collection("vehicles").doc(query).set({
                                                'query': query,
                                                'vehicle': vplate,
                                                'vehiclebrand': vbrand,
                                                'vehicledesc': vdesc,
                                                'vehiclekind': vkind,
                                                'vehiclemodel': vmodel,
                                                // 'addedby': 'toadd',
                                                // 'addedtime': Timestamp.now(),
                                                'editedby': 'toadd',
                                                'editedtime': Timestamp.now(),
                                                'reason': vreas,
                                              }).then((value) {
                                                FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
                                                  // 'collectionid2': collectionid2,
                                                  'lastactivity.datetime': Timestamp.now(),
                                                }).then((value) {
                                                  FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
                                                    // 'collectionid2': collectionid2,
                                                    'userid': user.uid,
                                                    'userfullname': usercheck,
                                                    'this.collectionid': collectionid2,
                                                    'activity': activity,
                                                    'editcreate.datetime': Timestamp.now(),
                                                    'editcreate.collectionid': vplate,
                                                  });
                                                });

                                                print("done");
                                                Get.offAll(VehicleList());
                                                Get.snackbar(
                                                  "Success!",
                                                  "Vehicle Edited!.",
                                                  duration: Duration(seconds: 3),
                                                );
                                                _showSuccessAlert(
                                                    title: "Congrats!",
                                                    content: "Successfully Edited!", //show error firebase
                                                    onPressed: _changeBlackVisible,
                                                    context: context);

                                                setState(() {
                                                  _btnController.reset();
                                                  _vehiclekindTextController.text = "";
                                                  _vehicleplateTextController.text = "";
                                                  _vehiclebrandTextController.text = "";
                                                  _vehiclemodelTextController.text = "";
                                                  _vehicledescTextController.text = "";
                                                  _vehiclereasTextController.text = "";
                                                  _btnController.reset();
                                                  // Get.snackbar(
                                                  //   "Success!",
                                                  //   "New Schedule Added.",
                                                  //   duration: Duration(seconds: 3),
                                                  // );
                                                  // Get.offAll(Dashboard());
                                                });
                                              });
                                            } else {
                                              var activity = 'Created a new hot-car with plate number: $vplate';

                                              User user = auth.currentUser;
                                              var currentUser = user.uid;
                                              var usercheck;
                                              var collectionid2 = uuid.v1();

                                              QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
                                              username.docs.forEach((document) {
                                                usercheck = document.data()['fullName'];
                                              });

                                              FirebaseFirestore.instance.collection("vehicles").doc(vplate).set({
                                                'query': vplate,
                                                'vehicle': vplate,
                                                'vehiclebrand': vbrand,
                                                'vehicledesc': vdesc,
                                                'vehiclekind': vkind,
                                                'vehiclemodel': vmodel,
                                                'addedby': 'toadd',
                                                'addedtime': Timestamp.now(),
                                                'reason': vreas,
                                              }).then((value) {
                                                FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
                                                  // 'collectionid2': collectionid2,
                                                  'lastactivity.datetime': Timestamp.now(),
                                                }).then((value) {
                                                  FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
                                                    // 'collectionid2': collectionid2,
                                                    'userid': user.uid,
                                                    'userfullname': usercheck,
                                                    'this.collectionid': collectionid2,
                                                    'activity': activity,
                                                    'editcreate.datetime': Timestamp.now(),
                                                    'editcreate.collectionid': vplate,
                                                  });
                                                });

                                                print("done");
                                                Get.offAll(VehicleList());
                                                Get.snackbar(
                                                  "Success!",
                                                  "New Vehicle Added.",
                                                  duration: Duration(seconds: 3),
                                                );
                                                _showSuccessAlert(
                                                    title: "Congrats!",
                                                    content: "Successfully Created!", //show error firebase
                                                    onPressed: _changeBlackVisible,
                                                    context: context);

                                                setState(() {
                                                  _btnController.reset();
                                                  _vehiclekindTextController.text = "";
                                                  _vehicleplateTextController.text = "";
                                                  _vehiclebrandTextController.text = "";
                                                  _vehiclemodelTextController.text = "";
                                                  _vehicledescTextController.text = "";
                                                  _vehiclereasTextController.text = "";
                                                  _btnController.reset();
                                                  // Get.snackbar(
                                                  //   "Success!",
                                                  //   "New Schedule Added.",
                                                  //   duration: Duration(seconds: 3),
                                                  // );
                                                  // Get.offAll(Dashboard());
                                                });
                                              });
                                            }
                                          } catch (e) {
                                            setState(() {
                                              _btnController.reset();
                                              _btnController.reset();
                                              _vehiclekindTextController.text = "";
                                              _vehicleplateTextController.text = "";
                                              _vehiclebrandTextController.text = "";
                                              _vehiclemodelTextController.text = "";
                                              _vehicledescTextController.text = "";
                                              _vehiclereasTextController.text = "";
                                            });
                                            _showErrorAlert(
                                                title: "ADDING FAILED",
                                                content: e.printError(), //show error firebase
                                                onPressed: _changeBlackVisible,
                                                context: context);
                                          }

                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          print("hindi");
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  signOut() {
    User user = auth.currentUser;
    var collectionid2 = uuid.v1();

    FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
      'lastactivity.datetime': Timestamp.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
        'userid': user.uid,
        'activity': 'Logged out session.',
        'editcreate.datetime': Timestamp.now(),
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
            gradient: new LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
                    physics: BouncingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Color(0xff1D976C),
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
                                      "Vehicle List",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: AvatarGlow(
                                      startDelay: Duration(milliseconds: 0),
                                      glowColor: Colors.lime,
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
                              'https://cloudfront-us-east-1.images.arcpublishing.com/cmg/PZQVBPFW2FXTEMMO2EVXFTEXJA.jpg',
                              fit: BoxFit.cover,
                            )),
                        expandedHeight: 200,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int pdIndex) {
                            return SingleChildScrollView(
                              child: Column(children: [
                                Row(
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 30, bottom: 80),
                                              child: Container(
                                                  width: 365,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(10.0),
                                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                                                  ),
                                                  child:
                                                      // Container()),
                                                      _buildMain2()),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                                //... The children inside the column of ListView.builder
                              ]),
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
                              painter: DrawerPainter(offset: _offset),
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
                                          Image.asset(
                                            "assets/images/hospital.png",
                                            width: sidebarSize / 3,
                                          ),
                                          Text(
                                            "Big PP",
                                            style: TextStyle(color: Colors.black45),
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
                                        MyButton(text: "Schedule Details", iconData: Icons.text_snippet, textSize: getSize(0), height: (menuContainerHeight) / 6, selectedIndex: 0),
                                        MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 6, selectedIndex: 4),
                                        MyButton(text: "Add Schedule", iconData: Icons.library_add_check, textSize: getSize(2), height: (menuContainerHeight) / 6, selectedIndex: 1),
                                        MyButton(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 2),
                                        MyButton(text: "Reset User Password", iconData: Icons.local_car_wash, textSize: getSize(4), height: (menuContainerHeight) / 6, selectedIndex: 3),

                                        // MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                        // MyButton(
                                        //     text: "Fourth",
                                        //     iconData: Icons.settings,
                                        //     textSize: getSize(4),
                                        //     height: (menuContainerHeight) / 5,
                                        //     selectedIndex: 4),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Logout Confirmation"),
                                                content: const Text("Are you sure you want to log out?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () => {
                                                            signOut(),
                                                          },
                                                      child: const Text("Yes")),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout,
                                            color: Colors.lightGreen,
                                            size: 20.0,
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
