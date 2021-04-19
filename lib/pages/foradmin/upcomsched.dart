import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/editsched.dart';
import 'package:get_rekk/pages/try.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:intl/intl.dart';

import 'newEditSched.dart';

class UpcomingState extends StatefulWidget {
  @override
  _UpcomingStateState createState() => _UpcomingStateState();
}

FirebaseAuth auth = FirebaseAuth.instance;
bool isInvolve = false;

String why;
String whydesc;
String whykind;
String whymodel;
String whybrand;
String whyreason;

class _UpcomingStateState extends State<UpcomingState> {
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

              final filteredDocs = snapshot.data.docs.where((doc) => DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['starttime']).isAfter(DateTime.now()) && DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['endtime']).isAfter(DateTime.now())).toList();

              return Container(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (_, index) {
                    // print(snapshot.data.docs[index]['datecreated'].toDate());
                    // var a = DateTime.parse(snapshot.data.docs[index]['endtime'].toString());
                    var a = DateFormat('MM-dd-yyyy HH:mm a').parse(filteredDocs[index]['endtime'].toString());
                    print(filteredDocs[index]['endtime'].toString() + "aaa");
                    String formattedTime = DateFormat.Hm().format(a);
                    print(formattedTime + "aaa");
                    var b = DateFormat('MM-dd-yyyy HH:mm a').parse(filteredDocs[index]['starttime'].toString());
                    String formattedTime1 = DateFormat.Hm().format(b);

                    var c = DateFormat('MM-dd-yyyy').parse(filteredDocs[index]['starttime'].toString());
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
                                          "Status: Pending",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                var a = filteredDocs[index]['loclat'].toString();
                                final newString = a.replaceAll('[', '');
                                final newString2 = newString.replaceAll(']', '');

                                var a1 = filteredDocs[index]['loclng'].toString();
                                final newString3 = a1.replaceAll('[', '');
                                final newString4 = newString3.replaceAll(']', '');

                                final qq = double.parse(newString2);
                                final zz = double.parse(newString4);

                                // LatLng()
                                Schedule.date = formattedTime2;
                                Schedule.collectionid = filteredDocs[index]["collectionid"];
                                Schedule.datecreated = filteredDocs[index]["datecreated"].toDate();
                                Schedule.endtimeFormatted = formattedTime;
                                Schedule.starttimeFormatted = formattedTime1;
                                Schedule.endtime = filteredDocs[index]["endtime"];
                                Schedule.starttime = filteredDocs[index]["starttime"];
                                Schedule.notes = filteredDocs[index]["notes"];
                                Schedule.missionname = filteredDocs[index]["missionname"];
                                Schedule.kind = filteredDocs[index]["kind"];
                                Schedule.location = filteredDocs[index]["location"];
                                Schedule.spotter = filteredDocs[index]["spotter"];
                                Schedule.teamlead = filteredDocs[index]["teamlead"];
                                Schedule.spokesperson = filteredDocs[index]["spokesperson"];
                                Schedule.status = filteredDocs[index]["status"];
                                Schedule.createdby = filteredDocs[index]["createdby"];
                                Schedule.blockteamname = new List<String>.from(filteredDocs[index]['blockteamname']);
                                Schedule.searchteamname = new List<String>.from(filteredDocs[index]['searchteamname']);
                                Schedule.secuteamname = new List<String>.from(filteredDocs[index]['secuteamname']);
                                Schedule.investteamname = new List<String>.from(filteredDocs[index]['investteamname']);
                                Schedule.blockteam = new List<String>.from(filteredDocs[index]['blockteam']);
                                Schedule.searchteam = new List<String>.from(filteredDocs[index]['searchteam']);
                                Schedule.secuteam = new List<String>.from(filteredDocs[index]['secuteam']);
                                Schedule.investteam = new List<String>.from(filteredDocs[index]['investteam']);
                                Schedule.vehicle = new List<String>.from(filteredDocs[index]['vehicle']);
                                Schedule.location = filteredDocs[index]['location'];
                                Schedule.latloc = qq;
                                Schedule.lngloc = zz;
                                Schedule.memberuid = new List<String>.from(filteredDocs[index]['memberuid']);
                                Schedule.flaggedvehicles = '';
                                Schedule.lastflag = '';
                                Schedule.scannedvehicles = '';
                                Schedule.lastscan = '';
                                print(Schedule.investteam);

                                if (Schedule.vehicle.isNotEmpty) {
                                  isInvolve = true;
                                } else {
                                  isInvolve = false;
                                }
                                _showModalSheetSearch(context);
                                print("lets see");
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

  _showModalSheetSearch(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (builder) {
        return SafeArea(
          left: true,
          top: false,
          right: true,
          bottom: false,
          minimum: const EdgeInsets.only(top: 25.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                  appBar: AppBar(
                    leading: BackButton(color: Colors.white),
                    title: Text("Details", style: TextStyle(color: Colors.white)),
                    backgroundColor: Color(0xff085078),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 38.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            var usercheck;
                            User user = auth.currentUser;
                            QuerySnapshot username = await FirebaseFirestore.instance.collection('users').where('collectionId', isEqualTo: user.uid).get();
                            username.docs.forEach((document) {
              usercheck = document.data()['fullName'];
                            });
                            // do something
                            for (var i = 0; i < Schedule.vehicle.length; i++) {
              QuerySnapshot snap = await FirebaseFirestore.instance.collection('vehicles').where("query", isEqualTo: Schedule.vehicle[i]).get();
              snap.docs.forEach((document) {
                FirebaseFirestore.instance.collection('trialvehicles').doc(Schedule.vehicle[i]).set({
                  'plate': document.data()['vehicle'],
                  // 'vehicle': document.data()['plate'],
                  'brand': document.data()['vehiclebrand'],
                  'desc': document.data()['vehicledesc'],
                  'kind': document.data()['vehiclekind'],
                  'model': document.data()['vehiclemodel'],
                }).then((value) {
                  // FirebaseFirestore.instance.collection("trialvehicles").doc(vehiclelist[i]).delete().then((value) {
                  //   print('deleted');
                  //   print(vehiclelist);
                  // });
                });
              });
                            }
                            var outputFormat2x = DateFormat('MM-dd-yyyy hh:mm a');
                            var finalCreatex = outputFormat2x.format(DateTime.now());
                            List<String> toadd = [];
                            toadd.add(usercheck.toString());
                            Schedule.editedtime = finalCreatex;
                            FirebaseFirestore.instance.collection("editedSchedule").doc(Schedule.collectionid).collection("editedSchedule").doc(finalCreatex).set({
              "teamlead": Schedule.teamlead,
              "spotter": Schedule.spotter,
              "spokesperson": Schedule.spokesperson,
              // "date": finalDate.toString(),
              "starttime": Schedule.starttime,
              "endtime": Schedule.endtime,
              "location": Schedule.location,
              "kind": Schedule.kind,
              "datecreated": Schedule.datecreated,
              "createdby": Schedule.createdby,
              "status": Schedule.status,
              "notes": Schedule.notes,
              "missionname": Schedule.missionname,
              "collectionid": Schedule.collectionid,
              "blockteamname": FieldValue.arrayUnion(Schedule.blockteamname),
              "investteamname": FieldValue.arrayUnion(Schedule.investteamname),
              "searchteamname": FieldValue.arrayUnion(Schedule.searchteamname),
              "secuteamname": FieldValue.arrayUnion(Schedule.secuteamname),
              "blockteam": FieldValue.arrayUnion(Schedule.blockteam),
              "investteam": FieldValue.arrayUnion(Schedule.investteam),
              "searchteam": FieldValue.arrayUnion(Schedule.searchteam),
              "secuteam": FieldValue.arrayUnion(Schedule.secuteam),
              "editedby": FieldValue.arrayUnion(toadd),
              "vehicle": Schedule.vehicle,
              "memberuid": FieldValue.arrayUnion(Schedule.memberuid),
              "editedtime": finalCreatex,
              'flaggedvehicles': Schedule.flaggedvehicles,
              'lastflag': Schedule.lastflag,
              'scannedvehicles': Schedule.scannedvehicles,
              'lastscan': Schedule.lastscan,
              // Schedule.latloc = filteredDocs[index]['loclat'].toDouble();
              //   Schedule.lngloc = filteredDocs[index]['lngloc'].toDouble();
              // "loclat": Schedule.latloc.toString(),
              // "loclng": Schedule.lngloc.toString()
                            });
                            Schedule.editedtime = finalCreatex;
                            Get.offAll(NewEditSched());
                          },
                        ),
                      )
                    ],
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
                    child: AutoSizeText(
                      Schedule.missionname,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
                    child: Container(
                      width: Get.width,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0, bottom: 30),
                                child: Container(
                                   width: Get.width,
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
                                                "${Schedule.notes} ",
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
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "*Tap on the Vehicle Number to see the details.",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12.0,
                                                              fontFamily: 'Nunito-Bold',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                                    itemCount: Schedule.vehicle.length,
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
                                                                title: Text(Schedule.vehicle[index]),
                                                                onTap: () async {
                                                                  // print(PastSchedule.missionid.toString());
                                                                  // showVehicleInfo(PastSchedule.flaggedvehicles[index]);
                                                                  fetchVehicleInfo(Schedule.vehicle[index]);
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
                              ),
                              Container(
                                width: 340,
                                height: 120,
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
                                                  "Team Leader: ",
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
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text("${Schedule.teamlead} "),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Spokesperson: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.spokesperson} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Spotter: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.spotter} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Date Scheduled: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.date} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Start Time: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.starttimeFormatted} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "End Time: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.endtimeFormatted} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Location: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.location} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Type of Mission: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.kind} "),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Container(
                                  width: 340,
                                  height: 120,
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
                                                    "Created By: ",
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
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text("${Schedule.createdby} "),
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
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  width: 352.5,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Investigation Sub Team: (${Schedule.investteamname.length})",
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child: Container(
                  height: 180,
                  width: 480,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: ListView.builder(
                      itemCount: Schedule.investteamname.length,
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
                                  title: Text(Schedule.investteamname[index]),
                                  onTap: () {},
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
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  width: 352.5,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Search Sub Team: (${Schedule.searchteamname.length})",
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child: Container(
                  height: 180,
                  width: 480,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: ListView.builder(
                      itemCount: Schedule.searchteamname.length,
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
                                  title: Text(Schedule.searchteamname[index]),
                                  onTap: () {},
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
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  width: 352.5,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Security Sub Team: (${Schedule.secuteamname.length})",
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child: Container(
                  height: 180,
                  width: 480,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: ListView.builder(
                      itemCount: Schedule.secuteamname.length,
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
                                  title: Text(Schedule.secuteamname[index]),
                                  onTap: () {},
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
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  width: 352.5,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Block Sub Team: (${Schedule.blockteamname.length})",
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0, bottom: 40),
                child: Container(
                  height: 180,
                  width: 480,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: ListView.builder(
                      itemCount: Schedule.blockteamname.length,
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
                                  title: Text(Schedule.blockteamname[index]),
                                  onTap: () {},
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
                        "Future Schedules",
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
