// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get_rekk/helpers/util.dart';

// class TryPage extends StatefulWidget {
//   @override
//   _TryPageState createState() => _TryPageState();
// }

// class _TryPageState extends State<TryPage> {
//   List<String> investteam = [];

//   getShop2() {
//     // var firestore = FirebaseFirestore.instanceFor();
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     Stream<QuerySnapshot> qn = _firestore.collection("users").snapshots();
//     return qn;
//   }

//   _showApprovedListx() {
//     return Container(
//       height: 300,
//       width: 480,
//       color: Colors.white,
//       child: StreamBuilder<QuerySnapshot>(
//         stream: getShop2(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('');
//           } else if (snapshot.connectionState == ConnectionState.done) {
//             return Text('');
//           } else {
//             if (snapshot.data == null) {
//               return Text('');
//             } else {
//               final List<DocumentSnapshot> userList = snapshot.data.docs.where((DocumentSnapshot documentSnapshot) {
//                 return investteam.contains(documentSnapshot['badgeNum']);
//               }).toList();
//               return Container(
//                 child: ListView.builder(
//                   itemCount: userList.length,
//                   itemBuilder: (_, index) {
//                     return Dismissible(
//                       key: Key('item ${userList[index]["badgeNum"]}'),
//                       background: Container(
//                         color: Colors.redAccent,
//                         child: Padding(
//                           padding: const EdgeInsets.all(15),
//                           child: Row(
//                             children: [
//                               Icon(Icons.delete, color: Colors.white),
//                               Text('Remove from the list', style: TextStyle(color: Colors.white)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       onDismissed: (DismissDirection direction) {
//                         if (direction == DismissDirection.startToEnd) {
//                         } else {}
//                       },
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(
//                             height: 18.0,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 color: Colors.white,
//                                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
//                               ),
//                               child: ListTile(
//                                 leading: Container(
//                                   padding: EdgeInsets.all(8.0),
//                                   // child: CircleAvatar(
//                                   //   backgroundImage: NetworkImage(_card["shopsdp"]),
//                                   // ),
//                                   child: Text("hellox"),
//                                 ),
//                                 title: Text(userList[index]["badgeNum"]),
//                                 subtitle: Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex: 1,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(left: 0.0),
//                                         child: Text(
//                                           userList[index]["badgeNum"].toString(),
//                                           style: TextStyle(color: Colors.black),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () {},
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
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
//     investteam = Schedule.investteam;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: <Widget>[
//             Stack(
//               alignment: Alignment.topCenter,
//               overflow: Overflow.visible,
//               children: <Widget>[
//                 Container(
//                   width: 330.0,
//                   child: Column(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 30.0, left: 5, bottom: 50),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Text(
//                                   "Block/Pursue Sub-Team",
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20.0,
//                                     fontFamily: 'Nunito-Bold',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 // _buildBlockSub(),
//                               ],
//                             ),
//                             _showApprovedListx(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
