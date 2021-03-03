import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/ongoingdetails.dart';
import 'package:intl/intl.dart';

class Ongoingsched extends StatefulWidget {
  @override
  _OngoingschedState createState() => _OngoingschedState();
}

getShop2() {
  // var firestore = FirebaseFirestore.instanceFor();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> qn = _firestore.collection("schedule").snapshots();
  // Stream<QuerySnapshot> qn = _firestore.collection("schedule").snapshots();

  return qn;
}

_buildFuture() {
  return Container(
    height: 300,
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

            final filteredDocs = snapshot.data.docs.where((doc) => DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['starttime']).isBefore(DateTime.now()) && DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['endtime']).isAfter(DateTime.now())).toList();

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
                                        "Status: Ongoing",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
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
                              Get.to(OngoingPage());
                              print("click");
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

class _OngoingschedState extends State<Ongoingsched> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            Column(
              children: <Widget>[
                new Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0, left: 16, right: 14),
                      child: Container(
                        width: 360,
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
                      padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 50, bottom: 40),
                      child: Container(
                        width: 365,
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
                                "Ongoing Schedules",
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
                                            Colors.greenAccent,
                                            Colors.green,
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
                ),
              ],
            ),
          ],
        )
        //... The children inside the column of ListView.builder
      ]),
    );
  }
}
