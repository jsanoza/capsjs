import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/ongoingdetails.dart';
import 'package:get_rekk/pages/forusers/usersongoingdetails.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/streams.dart';

class UsersOngoingSched extends StatefulWidget {
  @override
  _UsersOngoingSchedState createState() => _UsersOngoingSchedState();
}

bool _isEmpty = false;
FirebaseAuth auth = FirebaseAuth.instance;
List<String> hellothere = [];
List<String> scheduleuid = [''];
List<DocumentSnapshot> leaderList;

class _UsersOngoingSchedState extends State<UsersOngoingSched> {
  User user = auth.currentUser;

  getShop2() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("schedule").where('memberuid', arrayContains: user.uid).snapshots();
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
                    print(snapshot.data.docs[index]['datecreated'].toDate());
                    // var a = DateTime.parse(snapshot.data.docs[index]['endtime'].toString());
                    var a = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['endtime'].toString());
                    String formattedTime = DateFormat.jm().format(a);

                    var b = DateFormat('MM-dd-yyyy HH:mm').parse(filteredDocs[index]['starttime'].toString());
                    String formattedTime1 = DateFormat.jm().format(b);

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
                              title: Text(filteredDocs[index]['missionname']),
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
                                              formattedTime1,
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              " - ",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            Text(
                                              formattedTime,
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
                              onTap: () {},
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

  @override
  void initState() {
    // TODO: implement initState
    // if (UserSched.collectid.isNotEmpty) {
    hellothere.add(user.uid);
    _isEmpty = false;
    // }
    // print(UserSched.collectid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = auth.currentUser;
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
                        width: 345,
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
                        width: 350,
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
        ),

        //... The children inside the column of ListView.builder
      ]),
    );
  }
}
