import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/editsched.dart';
import 'package:get_rekk/pages/try.dart';
import 'package:intl/intl.dart';

class UsersUpcomingState extends StatefulWidget {
  @override
  _UsersUpcomingStateState createState() => _UsersUpcomingStateState();
}

FirebaseAuth auth = FirebaseAuth.instance;

String why;
String whydesc;
String whykind;
String whymodel;
String whybrand;
String whyreason;

class _UsersUpcomingStateState extends State<UsersUpcomingState> {
  User user = auth.currentUser;
  bool isInvolve = false;

  getShop2() {
    // check();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("schedule").where('memberuid', arrayContains: user.uid).snapshots();
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
              List<DocumentSnapshot> filteredDocs = snapshot.data.docs.where((doc) => DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['starttime']).isAfter(DateTime.now()) && DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['endtime']).isAfter(DateTime.now())).toList();
              return Container(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (_, index) {
                    var a = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['endtime'].toString());
                    print(filteredDocs[index]['endtime'].toString() + "aaa");
                    String formattedTime = DateFormat.jm().format(a);

                    var b = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['starttime'].toString());
                    String formattedTime1 = DateFormat.jm().format(b);

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
                                UserSched.date = formattedTime2;
                                UserSched.collectionid = filteredDocs[index]["collectionid"];
                                UserSched.datecreated = filteredDocs[index]["datecreated"].toDate();
                                UserSched.endtimeFormatted = formattedTime;
                                UserSched.starttimeFormatted = formattedTime1;
                                UserSched.endtime = filteredDocs[index]["endtime"];
                                UserSched.starttime = filteredDocs[index]["starttime"];
                                UserSched.notes = filteredDocs[index]["notes"];
                                UserSched.missionname = filteredDocs[index]["missionname"];
                                UserSched.kind = filteredDocs[index]["kind"];
                                UserSched.location = filteredDocs[index]["location"];
                                UserSched.spotter = filteredDocs[index]["spotter"];
                                UserSched.teamlead = filteredDocs[index]["teamlead"];
                                UserSched.spokesperson = filteredDocs[index]["spokesperson"];
                                UserSched.status = filteredDocs[index]["status"];
                                UserSched.createdby = filteredDocs[index]["createdby"];
                                UserSched.blockteamname = new List<String>.from(filteredDocs[index]['blockteamname']);
                                UserSched.searchteamname = new List<String>.from(filteredDocs[index]['searchteamname']);
                                UserSched.secuteamname = new List<String>.from(filteredDocs[index]['secuteamname']);
                                UserSched.investteamname = new List<String>.from(filteredDocs[index]['investteamname']);
                                UserSched.blockteam = new List<String>.from(filteredDocs[index]['blockteam']);
                                UserSched.searchteam = new List<String>.from(filteredDocs[index]['searchteam']);
                                UserSched.secuteam = new List<String>.from(filteredDocs[index]['secuteam']);
                                UserSched.investteam = new List<String>.from(filteredDocs[index]['investteam']);
                                UserSched.vehicle = new List<String>.from(filteredDocs[index]['vehicle']);
                                if (UserSched.vehicle.isNotEmpty) {
                                  isInvolve = true;
                                } else {
                                  isInvolve = false;
                                }
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

  _showModalSheetSearch(BuildContext context) {
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
                                  child: AutoSizeText(
                                    UserSched.missionname,
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
                                                              "${UserSched.notes} ",
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
                                                                  itemCount: UserSched.vehicle.length,
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
                                                                              title: Text(UserSched.vehicle[index]),
                                                                              onTap: () async {
                                                                                // print(PastSchedule.missionid.toString());
                                                                                // showVehicleInfo(PastSchedule.flaggedvehicles[index]);
                                                                                fetchVehicleInfo(UserSched.vehicle[index]);
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
                                                            title: Text("${UserSched.teamlead} "),
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
                                                              title: Text("${UserSched.spokesperson} "),
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
                                                              title: Text("${UserSched.spotter} "),
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
                                                              title: Text("${UserSched.date} "),
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
                                                              title: Text("${UserSched.starttimeFormatted} "),
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
                                                              title: Text("${UserSched.endtimeFormatted} "),
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
                                                              title: Text("${UserSched.location} "),
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
                                                              title: Text("${UserSched.kind} "),
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
                                                              title: Text("${UserSched.createdby} "),
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
                                                  "Investigation Sub Team: (${UserSched.investteamname.length})",
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
                                    itemCount: UserSched.investteamname.length,
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
                                                title: Text(UserSched.investteamname[index]),
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
                                                  "Search Sub Team: (${UserSched.searchteamname.length})",
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
                                    itemCount: UserSched.searchteamname.length,
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
                                                title: Text(UserSched.searchteamname[index]),
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
                                                  "Security Sub Team: (${UserSched.secuteamname.length})",
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
                                    itemCount: UserSched.secuteamname.length,
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
                                                title: Text(UserSched.secuteamname[index]),
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
                                                  "Block Sub Team: (${UserSched.blockteamname.length})",
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
                                    itemCount: UserSched.blockteamname.length,
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
                                                title: Text(UserSched.blockteamname[index]),
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
    // check();

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
                              gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
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
