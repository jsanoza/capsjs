import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:get/get.dart';
import 'package:get_rekk/animations/custom_alert_success.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/forcamera/flagged.dart';
import 'package:intl/intl.dart';

class DetailScreenx extends StatefulWidget {
  final String imagePath;
  final Function() notifyList;

  const DetailScreenx({Key key, this.imagePath, this.notifyList}) : super(key: key);
  // DetailScreenx(this.imagePath);

  @override
  _DetailScreenxState createState() => new _DetailScreenxState(imagePath);
}

class _DetailScreenxState extends State<DetailScreenx> {
  _DetailScreenxState(this.path);

  final String path;

  Size _imageSize;
  List<TextElement> _elements = [];
  List<TextBlock> _blocks = [];
  String recognizedText = "Loading ...";
  String condition;
  String userlevel;
  bool conditionvoi = false;
  bool _blackVisible = false;
  bool _isTrue = false;
  bool _isDone = false;
  var reason;
  var vehiclebrand;
  var vehiclemodel;
  var vehiclekind;
  var vehicledesc;
  var usercheck;
  var userwho;
  String formattedTime1;
  GlobalKey _toolTipKey = GlobalKey();

  String getWithoutSpaces(String s) {
    String tmp = s;
    // while(!tmp.startsWith(' ')){
    //  tmp = tmp.substring(1);
    // }
    while (tmp.endsWith('\n')) {
      tmp = tmp.substring(0, tmp.length - 1);
    }

    return tmp;
  }

  void _initializeVision() async {
    final File imageFile = File(path);
    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String pattern = r"^[A-Z]{0,4}[\s]*[0-9]{0,5}$";
    RegExp regEx = RegExp(pattern);

    var keys = ['APC', '7778', 'REGION', 'NCR', 'MC', 'POGI', 'LANG', 'TAKBO'];
    var regex1 = new RegExp("\\b(?:${keys.join('|')})\\b", caseSensitive: false);

    String mailAddress = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (!regex1.hasMatch(line.text)) {
          if (regEx.hasMatch(line.text)) {
            mailAddress = mailAddress + line.text;
            for (TextElement element in line.elements) {
              setState(() {
                _elements.add(element);
                _blocks.add(block);
                // mailAddress = Util.uid.toString();
              });
            }
            mailAddress = mailAddress + '\n';
          }
        }
      }
    }

    if (this.mounted) {
      setState(() {
        String hello = getWithoutSpaces(mailAddress);
        // recognizedText = hello;

        if (hello.contains('\n')) {
          print('yes');
          String resultx = hello.substring(0, hello.indexOf('\n'));
          print(resultx + 'helloroe');
          print('recognized' + recognizedText + 'ay');
          recognizedText = resultx;
        } else {
          print('no');
          recognizedText = hello;
        }

        checktoDB();
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    _initializeVision();
    super.initState();
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

  checktoDB() async {
    String plate = recognizedText;
    User user = auth.currentUser;
    String useruid = user.uid.toString();

    var a = await FirebaseFirestore.instance.collection('vehicles').where('vehicle', isEqualTo: plate).get();

    QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: useruid).get();
    username.docs.forEach((document) {
      usercheck = document.data()['badgeNum'].toString();
    });

    QuerySnapshot getLevel = await FirebaseFirestore.instance.collection('userlevel').where('badgeNum', isEqualTo: usercheck).get();
    getLevel.docs.forEach((document) {
      userlevel = document.data()['level'].toString();
    });

    if (a.docs.isNotEmpty) {
      setState(() {
        print('Exists');
        var hello = a.docs[0];
        DateTime dateNow = hello.data()['addedtime'].toDate();
        formattedTime1 = DateFormat.yMMMMd('en_US').add_jm().format(dateNow);
        reason = hello.data()['reason'];
        userwho = hello.data()['addedby'];
        vehiclebrand = hello.data()['vehiclebrand'];
        vehiclemodel = hello.data()['vehiclemodel'];
        vehiclekind = hello.data()['vehiclekind'];
        vehicledesc = hello.data()['vehicledesc'];
        print(formattedTime1.toString());
        print(reason.toString());
        print(vehiclemodel.toString());
        print(vehiclebrand.toString());
        print(vehiclekind.toString());
        print(vehicledesc.toString());
        condition = 'andito';
        conditionvoi = true;
        _isDone = true;
      });

      //if plate exists sa vehicle wanted list //alert now!
      // _btnController.reset();
      return true;
    }

    //another condition
    if (a.docs.isEmpty) {
      _isTrue = false;
      setState(() {
        condition = 'wala';
        conditionvoi = false;
        _isDone = true;
        print('wala tlga sya bro');
        // showAlertDialog(context);
      });

      // _btnController.reset();
      print('nope');
      return false;
    }
  }

  showSomeonez2(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(
          color: Colors.green,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        // savetoDB();
        // _btnController.reset();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Conflict", style: TextStyle(color: Colors.red)),
      content: Text(
        '''
This vehicle is on our list of vehicles of interest.


However, there is already another officer who reported this vehicle.
Therefore this will not be added on your list.

''',
        maxLines: 20,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSomeone(BuildContext context) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(
          color: Colors.green,
          fontSize: 20.0,
          fontFamily: 'Nunito-Bold',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        // savetoDB();
        // _btnController.reset();
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Conflict", style: TextStyle(color: Colors.red)),
      content: Text(
        '''
This vehicle is not on our list of vehicles.


However, there is already another officer who scanned this vehicle.
Therefore this will not be added on your list.

''',
        maxLines: 20,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  interest() async {
    User user = auth.currentUser;
    String plate = recognizedText;
    String finalUser;
    String finalRank;
    List<String> listplate = [];
    listplate.add(plate);
    List<String> alluid = [];
    var collectionid2 = uuid.v1();
    List<String> scannedby = [];
    QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    usernamex.docs.forEach((document) {
      finalUser = document.data()['fullName'];
      finalRank = document.data()['rank'];
    });
    scannedby.add(plate + ' found by: ' + ' ' + finalRank + ' ' + finalUser);
    QuerySnapshot username = await FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: Schedule.collectionid.toString()).where('vointerest', arrayContains: plate).get();
    username.docs.forEach((document) {
      print('true' + 'MERON NA NITO SA DB BRO');
      _isTrue = true;
    });

    if (_isTrue == true) {
      print('show alert that there is already a scanned vehicle with this plate number!');
      showSomeonez2(context);
    } else {
      QuerySnapshot check = await FirebaseFirestore.instance.collection('users').where('collectionId', isNotEqualTo: 'dummy').get();
      check.docs.forEach((document) async {
        alluid.add(document.data()['collectionId'].toString());
      });

      QuerySnapshot getVehicleDetails = await FirebaseFirestore.instance.collection('vehicles').where('query', isEqualTo: recognizedText).get();
      getVehicleDetails.docs.forEach((document) {
        FirebaseFirestore.instance.collection('found').doc(recognizedText).set({
          'foundby': FieldValue.arrayUnion(scannedby),
          'foundtime': Timestamp.now(),
          'query': recognizedText,
          'foundwhere': Schedule.missionname.toString(),
          'foundwhereid': Schedule.collectionid,
          'vehicle': document.data()['vehicle'],
          'addedby': document.data()['addedby'],
          "reason": document.data()['reason'],
          "vehiclebrand": document.data()['vehiclebrand'],
          "vehicledesc": document.data()['vehicledesc'],
          "vehiclekind": document.data()['vehiclekind'],
          "vehiclemodel": document.data()['vehiclemodel'],
          "timestamp": document.data()['addedtime'],
        }).then((value) {
          FirebaseFirestore.instance.collection('vehicles').doc(recognizedText).delete();
        }).then((valuex) {
          FirebaseFirestore.instance.collection("schedule").doc(Schedule.collectionid.toString()).update({
            'vointerest': FieldValue.arrayUnion(listplate),
            'voilast': FieldValue.arrayUnion(scannedby),
          }).then((value) {
            FirebaseFirestore.instance.collection('flag').doc(listplate.toString()).set({
              'flaggedvehicles': FieldValue.arrayUnion(listplate),
              'lastflag': FieldValue.arrayUnion(scannedby),
              'collectionid': Schedule.collectionid,
              'reason': 'Found a vehicle on our vehicles of interests list!',
              'otherreason': 'Assistance needed!',
              'seen': FieldValue.arrayUnion(alluid),
            }).then((value) async {
              //add to sub document
              FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).collection('vointerest').doc(plate.toString()).set({
                'scannedvehicles': FieldValue.arrayUnion(listplate),
                'whoscanned': user.uid,
                'scannedtime': Timestamp.now(),
                'scannedby': user.uid,
              }).then((value) {
                //add to users document
                FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(Schedule.collectionid).collection('vointerest').doc(plate).set({
                  'scannedvehicles': plate,
                  'query': plate,
                  'scannedtime': Timestamp.now(),
                }).then((value) {
                  //add to usertrail
                  FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('schedscan').doc(collectionid2).set({
                    'userid': user.uid,
                    'this_collectionid': collectionid2,
                    'activity': 'Found a vehicle of interest with plate number: $plate',
                    'editcreate_datetime': Timestamp.now(),
                    'editcreate_collectionid': Schedule.collectionid,
                    'vehicle': plate,
                  });
                });
              });
            });
          });
        });
      });

      // FirebaseFirestore.instance
      //     .collection("vehicles")
      //     .doc(recognizedText.toString())
      //     .update({
      //   'status': 'found',
      //   'foundby': FieldValue.arrayUnion(scannedby),
      //   'foundbyuid': user.uid.toString(),
      //   'foundtime': Timestamp.now(),
      //   'foundonmission': Schedule.collectionid,
      // }).then((value) {
      //   FirebaseFirestore.instance
      //       .collection("schedule")
      //       .doc(Schedule.collectionid.toString())
      //       .update({
      //     'vointerest': FieldValue.arrayUnion(listplate),
      //     'voilast': FieldValue.arrayUnion(scannedby),
      //   }).then((value) {
      //     FirebaseFirestore.instance
      //         .collection('flag')
      //         .doc(listplate.toString())
      //         .set({
      //       'flaggedvehicles': FieldValue.arrayUnion(listplate),
      //       'lastflag': FieldValue.arrayUnion(scannedby),
      //       'collectionid': Schedule.collectionid,
      //       'reason': 'Found a vehicle on our vehicle of interest list!',
      //       'otherreason': 'Assistance needed!',
      //       'seen': FieldValue.arrayUnion(alluid),
      //     }).then((value) async {
      //       //add to sub document
      //       FirebaseFirestore.instance
      //           .collection('schedule')
      //           .doc(Schedule.collectionid.toString())
      //           .collection('vointerest')
      //           .doc(plate.toString())
      //           .set({
      //         'scannedvehicles': FieldValue.arrayUnion(listplate),
      //         'whoscanned': user.uid,
      //         'scannedtime': Timestamp.now(),
      //         'scannedby': user.uid,
      //       }).then((value) {
      //         //add to users document
      //         FirebaseFirestore.instance
      //             .collection('users')
      //             .doc(user.uid)
      //             .collection('schedule')
      //             .doc(Schedule.collectionid)
      //             .collection('vointerest')
      //             .doc(plate)
      //             .set({
      //           'scannedvehicles': plate,
      //           'query': plate,
      //           'scannedtime': Timestamp.now(),
      //         }).then((value) {
      //           //add to usertrail
      //           FirebaseFirestore.instance
      //               .collection('usertrail')
      //               .doc(user.uid)
      //               .collection('schedscan')
      //               .doc(collectionid2)
      //               .set({
      //             'userid': user.uid,
      //             'this_collectionid': collectionid2,
      //             'activity':
      //                 'Found a vehicle of interest with plate number: $plate',
      //             'editcreate_datetime': Timestamp.now(),
      //             'editcreate_collectionid': Schedule.collectionid,
      //             'vehicle': plate,
      //           });
      //         });
      //       });
      //     });
      //   });
      // });
      //else add the plate to the list in the schedule

      _showSuccessAlert(
          title: "Success!",
          content: "Added!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      // Get.back();
      // _vehicleplateTextController.text = '';
    }
  }

  savetoDB() async {
    User user = auth.currentUser;
    String plate = recognizedText;
    List<String> listplate = [];
    List<String> scannedby = [];
    String finalUser;
    String finalRank;
    listplate.add(plate);
    var collectionid2 = uuid.v1();
    print(plate);
    //first get the users full name
    QuerySnapshot usernamex = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
    usernamex.docs.forEach((document) {
      finalUser = document.data()['fullName'];
      finalRank = document.data()['rank'];
    });
    scannedby.add(plate + ' scanned by: ' + ' ' + finalRank + ' ' + finalUser);
    //check if vehicle is already scanned
    QuerySnapshot username = await FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: Schedule.collectionid.toString()).where('scannedvehicles', arrayContains: plate).get();
    username.docs.forEach((document) {
      print('true' + 'MERON NA NITO SA DB BRO');
      _isTrue = true;
    });
    //show flagged here if resisting ang perpetrator
    if (_isTrue == true) {
      print('show alert that there is already a scanned vehicle with this plate number!');
      showSomeone(context);
    } else {
      //else add the plate to the list in the schedule
      FirebaseFirestore.instance.collection("schedule").doc(Schedule.collectionid.toString()).update({
        'scannedvehicles': FieldValue.arrayUnion(listplate),
        'lastscan': FieldValue.arrayUnion(scannedby),
      }).then((value) async {
        //add to sub document
        FirebaseFirestore.instance.collection('schedule').doc(Schedule.collectionid.toString()).collection('spot').doc(plate.toString()).set({
          'scannedvehicles': FieldValue.arrayUnion(listplate),
          'whoscanned': user.uid,
          'scannedtime': Timestamp.now(),
          'scannedby': user.uid,
        }).then((value) {
          //add to users document
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(Schedule.collectionid).collection('scannedvehicles').doc(plate).set({
            'scannedvehicles': plate,
            'query': plate,
            'scannedtime': Timestamp.now(),
          }).then((value) {
            //add to usertrail
            FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('schedscan').doc(collectionid2).set({
              'userid': user.uid,
              'this_collectionid': collectionid2,
              'activity': 'Scanned a vehicle with plate number: $plate',
              'editcreate_datetime': Timestamp.now(),
              'editcreate_collectionid': Schedule.collectionid,
              'vehicle': plate,
            });
          });
        });
      });
      _showSuccessAlert(
          title: "Success!",
          content: "Added into your scanned list!", //show error firebase
          onPressed: _changeBlackVisible,
          context: context);
      // _vehicleplateTextController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Backbutton pressed (device or appbar button), do whatever you want.');
        widget.notifyList();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff085078),
          title: Text(
            "Plate Details",
            style: TextStyle(color: Colors.white),
          ),
          // ignore: missing_required_param
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            },
            // onPressed: () => Get.to(CameraApp(), transition: Transition.fadeIn),
          ),
        ),
        body: _imageSize != null
            ? SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    _isDone
                        ? Container(
                            height: Get.height,
                            width: Get.width,
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: double.maxFinite,
                                  height: 300,
                                  color: Colors.black,
                                  child: CustomPaint(
                                    foregroundPainter: TextDetectorPainter(_imageSize, _blocks),
                                    child: AspectRatio(
                                      aspectRatio: _imageSize.aspectRatio,
                                      child: Image.file(
                                        File(path),
                                      ),
                                    ),
                                  ),
                                ),
                                conditionvoi
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Card(
                                          elevation: 8,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(),
                                                Container(
                                                  height: 50,
                                                  child: SingleChildScrollView(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        AutoSizeText(
                                                          recognizedText,
                                                          style: TextStyle(color: Colors.red, fontSize: 30),
                                                          overflow: TextOverflow.ellipsis,
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
                                                              icon: Icon(Icons.info, size: 38.0, color: Colors.red),
                                                            ),
                                                            message: '\n' +
                                                                recognizedText.toString() +
                                                                '\n\n' +
                                                                vehicledesc.toString() +
                                                                '\n' +
                                                                vehiclemodel.toString() +
                                                                '\n' +
                                                                vehiclekind.toString() +
                                                                '\n' +
                                                                vehiclebrand.toString() +
                                                                '\n\nREASON: ' +
                                                                reason.toString() +
                                                                '\n\n\nADDED TIME: ' +
                                                                formattedTime1.toString(),
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 18.0, left: 8, right: 8, top: 20),
                                                  child: Text(
                                                    "THIS VEHICLE IS ON OUR LIST!",
                                                    style: TextStyle(color: Colors.red, fontSize: 24),
                                                  ),
                                                ),
                                                Container(
                                                  // height: 100,
                                                  width: Get.width,
                                                  child: SingleChildScrollView(
                                                    child: AutoSizeText(
                                                      '''
Click on the Information button to see the details.

Click on the Notify Now button to notify all team mates.

''',
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Color(0xff085078), // background
                                                          onPrimary: Colors.white, // foreground
                                                        ),
                                                        icon: Icon(Icons.report_problem_outlined),
                                                        label: Text("Notify now!"),
                                                        onPressed: () async {
                                                          interest();
                                                        }),
                                                    //   Get.offAll(Flagged(
                                                    //       vehicle: recognizedText,
                                                    //       wherefrom: userlevel));
                                                    // }),
                                                    // ElevatedButton.icon(
                                                    //     style: ElevatedButton.styleFrom(
                                                    //       primary:
                                                    //           Color(0xff085078), // background
                                                    //       onPrimary:
                                                    //           Colors.white, // foreground
                                                    //     ),
                                                    //     icon: Icon(Icons.add_box_outlined),
                                                    //     label: Text("Submit"),
                                                    //     onPressed: () {
                                                    //       savetoDB();
                                                    //     }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Card(
                                          elevation: 8,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(),
                                                Container(
                                                  height: 50,
                                                  child: SingleChildScrollView(
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        recognizedText,
                                                        style: TextStyle(color: Colors.black, fontSize: 30),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Not on our list!",
                                                  style: TextStyle(color: Colors.green, fontSize: 30),
                                                ),
                                                Container(
                                                  // height: 100,
                                                  width: Get.width,
                                                  child: SingleChildScrollView(
                                                    child: AutoSizeText(
                                                      '''
This vehicle is not on our list.

Please choose carefully whether to Flag
this vehicle or not.

''',
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Color(0xff085078), // background
                                                          onPrimary: Colors.white, // foreground
                                                        ),
                                                        icon: Icon(Icons.flag_outlined),
                                                        label: Text("Flag"),
                                                        onPressed: () async {
                                                          Get.offAll(Flagged(vehicle: recognizedText, wherefrom: userlevel));
                                                        }),
                                                    ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: Color(0xff085078), // background
                                                          onPrimary: Colors.white, // foreground
                                                        ),
                                                        icon: Icon(Icons.add_box_outlined),
                                                        label: Text("Submit"),
                                                        onPressed: () {
                                                          savetoDB();
                                                        }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(
                            height: Get.height,
                            width: Get.width,
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ],
                ),
              )
            : Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.blocks);

  final Size absoluteImageSize;
  // final List<TextElement> elements;

  final List<TextBlock> blocks;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextBlock block in blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          print(element.text);
        }
        // paint.color = Colors.yellow;
        // canvas.drawRect(scaleRect(line), paint);
      }
      paint.color = Colors.red;
      canvas.drawRect(scaleRect(block), paint);
    }
    //old
    // for (TextElement element in elements) {
    //   canvas.drawRect(scaleRect(element), paint);
    // }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
