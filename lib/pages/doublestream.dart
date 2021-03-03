// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_rekk/helpers/util.dart';
// import 'package:get_rekk/pages/foradmin/ongoingdetails.dart';
// import 'package:get_rekk/pages/forusers/usersongoingdetails.dart';
// import 'package:intl/intl.dart';
// import 'package:rxdart/streams.dart';

// class UsersOngoingSched extends StatefulWidget {
//   @override
//   _UsersOngoingSchedState createState() => _UsersOngoingSchedState();
// }

// bool _isEmpty = false;
// FirebaseAuth auth = FirebaseAuth.instance;
// List<String> hellothere;

// class _UsersOngoingSchedState extends State<UsersOngoingSched> {
//   getShop2() {
//     User user = auth.currentUser;
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     Stream<QuerySnapshot> qn = _firestore.collection("users").doc(user.uid).collection('schedule').snapshots();
//     // setState(() {
//     //   _isEmpty = true;
//     // });
//     return qn;
//   }

//   _buildFuture() {
//     User user = auth.currentUser;
//     // final chatStream =

//     Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').snapshots();
//     Stream<QuerySnapshot> userStream = FirebaseFirestore.instance.collection('schedule').snapshots();
// // <List<QuerySnapshot>> combinedStream = combineLatest2(
// //         chatStream, userStream, (messages, users) => [messages, users]);

//     return Container(
//       height: 300,
//       width: 480,
//       color: Colors.white,
//       child: StreamBuilder(
//         stream: CombineLatestStream.list([
//           chatStream,
//           userStream,
//         ]),
//         builder: (BuildContext context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('');
//           } else if (snapshot.connectionState == ConnectionState.done) {
//             return Text('');
//           } else {
//             if (snapshot.data == null) {
//               return Text('');
//             } else {
//               // List<String> listitems = ["John", "James"];
//               // final List<dynamic> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
//               //   return !listitems.contains(documentSnapshot['scheduleuid']);
//               // }).toList();
//               // print(userList.length);

//               // List<String> liked;
//               // snapshot.data.docs.forEach((element) {
//               //   liked.add(element.get("scheduleuid"));
//               // });
//               // List<QueryDocumentSnapshot> liked = snapshot.data.docs.toList();
//               // final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
//               //   return userSearchItemsName.contains(documentSnapshot['badgeNum']);
//               // }).toList();

//               // final filteredDocs = userList.where((doc) => DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['starttime']).isBefore(DateTime.now()) && DateFormat('MM-dd-yyyy HH:mm').parse(doc.data()['endtime']).isAfter(DateTime.now())).toList();

//               List<QuerySnapshot> querySnapshotData = snapshot.data.toList();
//               List<QuerySnapshot> querySnapshotData2 = snapshot.data.toList();
//               // querySnapshotData[0].docs.addAll(querySnapshotData[1].docs);
//               // print(querySnapshotData[0].docs[0]['scheduleuid']);

//               // final List<DocumentSnapshot> userList = querySnapshotData[1].docs.where((DocumentSnapshot documentSnapshot) {
//               //   return querySnapshotData[0].docs[0]['scheduleuid'].contains(documentSnapshot['collectionid']);
//               // }).toList();
//               // print(userList.length);

//               // querySnapshotData[1].docs.forEach((element) {
//               //   // print(element.data().containsValue('5bdec034-2c29-41f8-936d-a096a2dfc39b'));
//               //   // element.data().addAll(other);
//               // });
//               // for (var i = 0; i < querySnapshotData[1].docs.length; i++) {
//               //   var j;
//               //   print(querySnapshotData[1].docs[i]['collectionid'].toString());
//               //   j = querySnapshotData[1].docs[i]['collectionid'].toString();
//               //   print(j);

//               //   // hellothere = querySnapshotData[1].docs[i]['collectionid'];
//               // }
//               // print(hellothere);

//               return Container(
//                 child: ListView.builder(
//                   itemCount: querySnapshotData.length,
//                   itemBuilder: (_, index) {
//                     // print(snapshot.data.docs[index]['datecreated'].toDate());
//                     // var a = DateTime.parse(snapshot.data.docs[index]['endtime'].toString());
//                     // var a = DateFormat('MM-dd-yyyy HH:mm').parse(snapshot.data.docs[index]['endtime'].toString());
//                     // String formattedTime = DateFormat.jm().format(a);

//                     // var b = DateFormat('MM-dd-yyyy HH:mm').parse(snapshot.data.docs[index]['starttime'].toString());
//                     // String formattedTime1 = DateFormat.jm().format(b);

//                     // var c = DateFormat('MM-dd-yyyy').parse(snapshot.data.docs[index]['starttime'].toString());
//                     // String formattedTime2 = DateFormat.yMd().format(c);
//                     // print(snapshot.data[0].docs[index]['scheduleuid']);
//                     // print(snapshot.data[1].docs[index]['collectionid']);

//                     // List<dynamic> hello = snapshot.data[0].docs[index]['scheduleuid'];

//                     // print(a);
//                     // hellothere.add(querySnapshotData[1].docs[index]['collectionid']);
//                     return StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance.collection('schedule').where('collectionid', isEqualTo: querySnapshotData[0].docs[index]['scheduleuid']).snapshots(),
//                         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                           return Column(
//                             children: <Widget>[
//                               SizedBox(
//                                 height: 0.0,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 0.0, left: 8.0, right: 8.0, top: 30),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     color: Colors.white,
//                                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
//                                   ),
//                                   child: ListTile(
//                                     leading: Container(
//                                       padding: EdgeInsets.only(left: 8.0, right: 8, top: 12),
//                                       // child: CircleAvatar(
//                                       //   backgroundImage: NetworkImage(_card["shopsdp"]),
//                                       // ),
//                                       child: Text(''),
//                                     ),
//                                     title: Text(snapshot.data.docs[index]['missionname']),
//                                     subtitle: Container(
//                                       height: 50,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Expanded(
//                                             flex: 1,
//                                             child: Padding(
//                                               padding: EdgeInsets.only(left: 0.0),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     ' ',
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     " - ",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     '',
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Padding(
//                                               padding: EdgeInsets.only(left: 0.0),
//                                               child: Text(
//                                                 "Status: Ongoing",
//                                                 style: TextStyle(color: Colors.black),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       // Schedule.date = formattedTime2;
//                                       // Schedule.collectionid = filteredDocs[index]["collectionid"];
//                                       // Schedule.datecreated = filteredDocs[index]["datecreated"].toDate();
//                                       // Schedule.endtimeFormatted = formattedTime;
//                                       // Schedule.starttimeFormatted = formattedTime1;
//                                       // Schedule.endtime = filteredDocs[index]["endtime"];
//                                       // Schedule.starttime = filteredDocs[index]["starttime"];
//                                       // Schedule.notes = filteredDocs[index]["notes"];
//                                       // Schedule.missionname = filteredDocs[index]["missionname"];
//                                       // Schedule.kind = filteredDocs[index]["kind"];
//                                       // Schedule.location = filteredDocs[index]["location"];
//                                       // Schedule.spotter = filteredDocs[index]["spotter"];
//                                       // Schedule.teamlead = filteredDocs[index]["teamlead"];
//                                       // Schedule.spokesperson = filteredDocs[index]["spokesperson"];
//                                       // Schedule.status = filteredDocs[index]["status"];
//                                       // Schedule.createdby = filteredDocs[index]["createdby"];
//                                       // Schedule.blockteamname = new List<String>.from(filteredDocs[index]['blockteamname']);
//                                       // Schedule.searchteamname = new List<String>.from(filteredDocs[index]['searchteamname']);
//                                       // Schedule.secuteamname = new List<String>.from(filteredDocs[index]['secuteamname']);
//                                       // Schedule.investteamname = new List<String>.from(filteredDocs[index]['investteamname']);
//                                       // Schedule.blockteam = new List<String>.from(filteredDocs[index]['blockteam']);
//                                       // Schedule.searchteam = new List<String>.from(filteredDocs[index]['searchteam']);
//                                       // Schedule.secuteam = new List<String>.from(filteredDocs[index]['secuteam']);
//                                       // Schedule.investteam = new List<String>.from(filteredDocs[index]['investteam']);
//                                       Get.to(UsersOngoingDetailsPage());
//                                       print("click");
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         });
//                   },
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     // if (UserSched.collectid.isNotEmpty) {
//     //   _isEmpty = true;
//     // }
//     // print(UserSched.collectid);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(children: [
//         Row(
//           children: [
//             Column(
//               children: <Widget>[
//                 new Stack(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 100.0, left: 16, right: 14),
//                       child: Container(
//                         width: 360,
//                         height: 500,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: new BorderRadius.circular(10.0),
//                           boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
//                         ),
//                         child: _buildFuture(),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 14.0, right: 10.0, top: 50, bottom: 40),
//                       child: Container(
//                         width: 365,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: new BorderRadius.circular(10.0),
//                           boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
//                         ),
//                         child: Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 top: 20.0,
//                                 right: 0,
//                               ),
//                               child: Text(
//                                 "Ongoing Schedules",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 30.0,
//                                   fontFamily: 'Nunito-Bold',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(top: 10.0, bottom: 20),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       gradient: new LinearGradient(
//                                           colors: [
//                                             Colors.greenAccent,
//                                             Colors.green,
//                                           ],
//                                           begin: const FractionalOffset(0.0, 0.0),
//                                           end: const FractionalOffset(1.0, 1.0),
//                                           stops: [0.0, 1.0],
//                                           tileMode: TileMode.clamp),
//                                     ),
//                                     width: 125.0,
//                                     height: 1.0,
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // _buildTeam(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         )
//         //... The children inside the column of ListView.builder
//       ]),
//     );
//   }
// }
