// import 'dart:async';
// import 'dart:math';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_rekk/helpers/navbuttonusers.dart';
// import 'package:get_rekk/helpers/util.dart';
// import 'package:get_rekk/pages/foradmin/ongoingsched.dart';
// import 'package:get_rekk/pages/foradmin/passsched.dart';
// import 'package:get_rekk/pages/foradmin/upcomsched.dart';
// import 'package:get_rekk/pages/forusers/usersongoing.dart';
// import 'package:get_rekk/pages/forusers/userspasssched.dart';
// import 'package:get_rekk/pages/forusers/userssched.dart';
// import 'package:get_rekk/pages/forusers/usersupcomsched.dart';
// import 'package:get_rekk/pages/loginsignup.dart';

// class Loading extends StatefulWidget {
//   @override
//   _LoadingState createState() => _LoadingState();
// }

// class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
//   @override
//   // ignore: override_on_non_overriding_member

//   FirebaseAuth auth = FirebaseAuth.instance;

//   String badge;

//   @override
//   void initState() {
//     // getBadge();
//     check();
//     super.initState();
//   }

//   Future getBadge() async {
//     String collectid;

//     var a = await FirebaseFirestore.instance.collection('users').where("collectionId", isEqualTo: user.uid).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       collectid = hello.data()['badgeNum'];
//       UserSched.badge = collectid;
//       UserSched.badgename = hello.data()['fullName'];
//       print(UserSched.badge);
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getCheckBlock(String badge) async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('blockteam', arrayContains: UserSched.badge).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       UserSched.collectid.add(hello.data()['collectionid']);
//       print(UserSched.collectid);
//       // print("yes");
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getCheckSecu(String badge) async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('secuteam', arrayContains: UserSched.badge).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       UserSched.collectid.add(hello.data()['collectionid']);
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getCheckInvest(String badge) async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('investteam', arrayContains: UserSched.badge).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       UserSched.collectid.add(hello.data()['collectionid']);
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getCheckSearch(String badge) async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('searchteam', arrayContains: UserSched.badge).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       UserSched.collectid.add(hello.data()['collectionid']);
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getTeamlead() async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('teamlead', isEqualTo: UserSched.badgename).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];

//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getSpotter(String badge) async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('spotter', isEqualTo: UserSched.badgename).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       UserSched.collectid.add(hello.data()['collectionid']);
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future getSpokesperson(String badge) async {
//     var a = await FirebaseFirestore.instance.collection('schedule').where('spokesperson', isEqualTo: UserSched.badgename).get();
//     if (a.docs.isNotEmpty) {
//       var hello = a.docs[0];
//       UserSched.collectid.add(hello.data()['collectionid']);
//       return true;
//     }
//     if (a.docs.isEmpty) {
//       return false;
//     }
//   }

//   Future check() async {
//     // var checkBlock = await getCheckBlock(UserSched.badge);
//     // print(checkBlock);
//     // var checkSecu = await getCheckSecu(UserSched.badge);
//     // print(checkSecu);
//     // var checkInvest = await getCheckInvest(UserSched.badge);
//     // print(checkInvest);
//     // var checkSearch = await getCheckSearch(UserSched.badge);
//     // print(checkSearch);
//     // var checkTeamlead = await getTeamlead(UserSched.badge);
//     // print(checkTeamlead);
//     // var checkSpotter = await getSpotter(UserSched.badge);
//     // print(checkSpotter);
//     // var checkSpokesperson = await getSpokesperson(UserSched.badge);
//     // print(checkSpokesperson);
//     // await getTeamlead();
//     if (UserSched.collectid.length == 0) {
//       print('walanglaman');
//       UserSched.collectid.add('02391872');
//     }

//     Timer(Duration(seconds: 3), () {
//       Get.offAll(UsersSched());
//     });

//     print(UserSched.collectid);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xff1D976C),
//                   Color(0xff93F9B9),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           Container(
//               child: Stack(
//             children: <Widget>[
//               Center(
//                   child: CircularProgressIndicator(
//                 backgroundColor: Colors.white,
//                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
//               )),
//             ],
//           ))
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
