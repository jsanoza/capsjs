import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:intl/intl.dart';

class PassschedState extends StatefulWidget {
  @override
  _PassschedStateState createState() => _PassschedStateState();
}

String why;
String whydesc;
String whykind;
String whymodel;
String whybrand;
String whyreason;

class _PassschedStateState extends State<PassschedState> {
  String reason;
  String whoscanned;
  DateTime datetime;
  String otherreason;
  String flaggedby;
  bool isInvolve = false;

  getShop2() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("schedule").snapshots();
    // Stream<QuerySnapshot> qn = _firestore.collection("schedule").snapshots();

    return qn;
  }

  _buildFuture() {
    return Container(
      height: Get.width,
      width: 480,
      color: Colors.white,
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
              // final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
              //   return userSearchItemsName.contains(documentSnapshot['badgeNum']);
              // }).toList();

              final filteredDocs = snapshot.data.docs.where((doc) => DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['endtime']).isBefore(DateTime.now())).toList();

              return Container(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (_, index) {
                    // print(snapshot.data.docs[index]['datecreated'].toDate());
                    // var a = DateTime.parse(snapshot.data.docs[index]['endtime'].toString());
                    var a = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['endtime'].toString());
                    String formattedTime = DateFormat.Hm().format(a);

                    var b = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['starttime'].toString());
                    String formattedTime1 = DateFormat.Hm().format(b);

                    var c = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['starttime'].toString());
                    String formattedTime2 = DateFormat.yMd().format(c);

                    print(a);
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: 0.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0, left: 8.0, right: 8.0, top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.only(left: 8.0, right: 8, top: 12),
                                // child: CircleAvatar(
                                //   backgroundImage: NetworkImage(_card["shopsdp"]),
                                // ),
                                child: Text(formattedTime2),
                              ),
                              title: Text(filteredDocs[index]["missionname"].toString()),
                              subtitle: Container(
                                height: 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              formattedTime1.toString(),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              " - ",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              formattedTime.toString(),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          "Status: Completed",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                PastSchedule.missionname = filteredDocs[index]['missionname'];
                                PastSchedule.starttime = filteredDocs[index]["starttime"];
                                PastSchedule.endtime = filteredDocs[index]["endtime"];
                                PastSchedule.purpose = filteredDocs[index]["notes"];
                                PastSchedule.missionid = filteredDocs[index]['collectionid'];
                                // PastSchedule.date = filteredDocs[index]["date"];
                                PastSchedule.flaggedvehicles = new List<String>.from(filteredDocs[index]['flaggedvehicles']);
                                PastSchedule.scannedvehicles = new List<String>.from(filteredDocs[index]['scannedvehicles']);
                                PastSchedule.vehicles = new List<String>.from(filteredDocs[index]['vehicle']);

                                why = '';
                                whydesc = '';
                                whykind = '';
                                whymodel = '';
                                whybrand = '';
                                whyreason = '';
                                if (PastSchedule.vehicles.isNotEmpty) {
                                  isInvolve = true;
                                } else {
                                  isInvolve = false;
                                }
                                // fetchVehicleInfo();
                                _showModalSheetSearch(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  fetchVehicleInfo(String index) async {
    QuerySnapshot search = await FirebaseFirestore.instance.collection('vehicles').where('query', isEqualTo: index).get();
    search.docs.forEach((element) {
      why = element.data()['query'];
      whydesc = element.data()['vehicledesc'];
      whykind = element.data()['vehiclekind'];
      whymodel = element.data()['vehiclemodel'];
      whybrand = element.data()['vehiclebrand'];
      whyreason = element.data()['reason'];
      print(element.data()['query']);
    });

    showAlertDialog(BuildContext context) {
      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed: () {
          // sendData();
          Get.back();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(index),
        content: Text(
          '''
The given description for this vehicle:
$whydesc


With the following specification: 
$whykind
$whybrand
$whymodel


Reason:
$whyreason
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
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }

  showVehicleInfo(String index) async {
    print("mi here");
    List<String> hello = [];
    hello.add(index);
    QuerySnapshot search = await FirebaseFirestore.instance.collection('schedule').doc(PastSchedule.missionid).collection('flagged').where('scannedvehicles', arrayContainsAny: hello).get();
    search.docs.forEach((document) async {
      setState(() {
        reason = document.data()['reason'];
        otherreason = document.data()['otherreason'];
        datetime = document.data()['scannedtime'].toDate();
        flaggedby = document.data()['flaggedby'];
        print(document.data());
        print("mi here");
      });
    });

    showAlertDialog(BuildContext context) {
      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed: () {
          // sendData();
          Get.back();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(index),
        content: Text(
          '''
was flagged by: 
$flaggedby


Reason/s for flagging: 
$reason
$otherreason


Date & Time of flagging:
${DateFormat.yMMMd().add_jm().format(datetime)}
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
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }

  _showModalSheetSearch(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
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
                  leading: BackButton(color: Colors.white),
                  title: Text("Details", style: TextStyle(color: Colors.white)),
                  backgroundColor: Color(0xff085078),
                  actions: <Widget>[],
                ),
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      PastSchedule.missionname,
                                      style: TextStyle(
                                        color: Color(0xff085078),
                                        fontSize: 40.0,
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 40,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 27.0, right: 0.0, top: 30.0),
                                  child: Container(
                                    width: 560,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 340,
                                              height: isInvolve ? 500 : 250,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                color: Colors.white,
                                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10.0),
                                                    child: Container(
                                                      width: 300,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Main Purpose of Deployment: ",
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 15.0,
                                                                  fontFamily: 'Nunito-Bold',
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 18.0),
                                                    child: Container(
                                                      width: 300,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        color: Colors.white,
                                                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                                      ),
                                                      child: Container(
                                                        child: ListTile(
                                                          title: AutoSizeText(
                                                            "${PastSchedule.purpose} ",
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 15.0,
                                                            ),
                                                            minFontSize: 15,
                                                            maxLines: 5,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  isInvolve
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(top: 20.0),
                                                          child: Container(
                                                            width: 300,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Vehicle Report: ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 15.0,
                                                                        fontFamily: 'Nunito-Bold',
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Text(''),
                                                  isInvolve
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                                                          child: Container(
                                                            height: 270,
                                                            width: 480,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.rectangle,
                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                              color: Colors.white,
                                                            ),
                                                            child: Container(
                                                              child: ListView.builder(
                                                                itemCount: PastSchedule.vehicles.length,
                                                                itemBuilder: (_, index) {
                                                                  // final DocumentSnapshot _card =
                                                                  //     userList[index];
                                                                  return Column(
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
                                                                            title: Text(PastSchedule.vehicles[index]),
                                                                            onTap: () async {
                                                                              // print(PastSchedule.missionid.toString());
                                                                              // showVehicleInfo(PastSchedule.flaggedvehicles[index]);
                                                                              fetchVehicleInfo(PastSchedule.vehicles[index]);
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Text(''),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: isInvolve ? const EdgeInsets.only(top: 530.0, bottom: 70) : const EdgeInsets.only(top: 270.0, bottom: 70),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 340,
                                                height: 400,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  color: Colors.white,
                                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Container(
                                                        width: 300,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "While at the deployment: ",
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 15.0,
                                                                    fontFamily: 'Nunito-Bold',
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0, left: 0),
                                                      child: Container(
                                                        width: 300,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Total # of scanned vehicles: " + "${PastSchedule.scannedvehicles.length} ",
                                                                  style: TextStyle(
                                                                    color: Colors.green,
                                                                    fontSize: 18.0,
                                                                    fontFamily: 'Nunito-Bold',
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0, left: 0),
                                                      child: Container(
                                                        width: 300,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Total # of flagged vehicles: " + "${PastSchedule.flaggedvehicles.length} ",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 18.0,
                                                                    fontFamily: 'Nunito-Bold',
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Click on the vehicle number to see the details: ",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 12.0,
                                                                    fontFamily: 'Nunito-Bold',
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                                                      child: Container(
                                                        height: 270,
                                                        width: 480,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                          color: Colors.white,
                                                        ),
                                                        child: Container(
                                                          child: ListView.builder(
                                                            itemCount: PastSchedule.flaggedvehicles.length,
                                                            itemBuilder: (_, index) {
                                                              // final DocumentSnapshot _card =
                                                              //     userList[index];
                                                              return Column(
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
                                                                        title: Text(PastSchedule.flaggedvehicles[index]),
                                                                        onTap: () async {
                                                                          print(PastSchedule.missionid.toString());
                                                                          showVehicleInfo(PastSchedule.flaggedvehicles[index]);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(top: 12.0),
                                                    //   child: Container(
                                                    //     width: 300,
                                                    //     decoration: BoxDecoration(
                                                    //       shape: BoxShape.rectangle,
                                                    //       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    //       color: Colors.white,
                                                    //       boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                                    //     ),
                                                    //     child: Container(
                                                    //       child: ListTile(
                                                    //         title: Text("${PastSchedule.scannedvehicles.length} "),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),

                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(top: 18.0),
                                                    //   child: Container(
                                                    //     width: 300,
                                                    //     decoration: BoxDecoration(
                                                    //       shape: BoxShape.rectangle,
                                                    //       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    //       color: Colors.white,
                                                    //       boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                                    //     ),
                                                    //     child: Container(
                                                    //       child: ListTile(
                                                    //         title: Text('Theres a to'),
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        new Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 25, right: 25),
              child: Container(
                width: Get.width,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: _buildFuture(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 50, bottom: 40),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        right: 0,
                      ),
                      child: Text(
                        "Past Schedules",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                    Color(0xff085078),
                                    Color(0xff85D8CE),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            width: 125.0,
                            height: 1.0,
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
        )
        //... The children inside the column of ListView.builder
      ]),
    );
  }
}
