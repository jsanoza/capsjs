import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:intl/intl.dart';
import 'package:time_elapsed/time_elapsed.dart';
import 'package:timer_builder/timer_builder.dart';

class OngoingdetailsPagetwo extends StatefulWidget {
  @override
  _OngoingdetailsPagetwoState createState() => _OngoingdetailsPagetwoState();
}

DateTime alert;

getShop2() {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<DocumentSnapshot> qn = _firestore.collection("schedule").doc(Schedule.collectionid).snapshots();
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
            final filteredDocs = snapshot.data.docs.where((doc) => DateFormat('MM-dd-yyyy HH:mm a').parse(doc.data()['starttime']).isAfter(DateTime.now()) && DateFormat('MM-dd-yyyy HH:mm a').parse(doc.data()['endtime']).isAfter(DateTime.now())).toList();
            return Container(
              child: ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (_, index) {
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
                          child: Container(),
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

class _OngoingdetailsPagetwoState extends State<OngoingdetailsPagetwo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Row(
          children: [
            Column(
              children: <Widget>[
                StreamBuilder<DocumentSnapshot>(
                    stream: getShop2(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('');
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        return Text('');
                      } else {
                        if (snapshot.data == null) {
                          return Text('');
                        } else {
                          return new Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 50, bottom: 0),
                                child: Container(
                                  width: 365,
                                  height: 300,
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
                                            padding: const EdgeInsets.only(top: 20.0, left: 20, bottom: 0),
                                            child: Text(
                                              "Feed",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30.0,
                                                fontFamily: 'Nunito-Bold',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0, top: 18),
                                        child: Row(
                                          children: [
                                            Text("Deployment active time:"),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 18.0),
                                              child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                                                var b = DateFormat('MM-dd-yyyy HH:mm').parse(snapshot.data["starttime"].toString());
                                                final Duration myDuration = DateTime.parse(b.toString()).difference(DateTime.now());
                                                final withoutEquals = myDuration.toString().replaceAll(RegExp('-'), '');
                                                final gg = withoutEquals.toString().split('.')[0];
                                                return Text(
                                                  "$gg ET",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontFamily: 'Nunito-Bold',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0, top: 20),
                                        child: Row(
                                          children: [
                                            Text("Scanned Vehicles:"),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0, top: 20),
                                        child: Row(
                                          children: [
                                            Text("Flagged Vehicles:"),
                                          ],
                                        ),
                                      ),

                                      // _buildTeam(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    }),
              ],
            ),
          ],
        )
        //... The children inside the column of ListView.builder
      ]),
    );
  }
}
