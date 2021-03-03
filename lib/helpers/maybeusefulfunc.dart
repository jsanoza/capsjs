// // getHello() async {
// //   // Stream<QuerySnapshot> productRef =
// //   //     FirebaseFirestore.instance.collection("users").snapshots();

// //   // productRef.forEach((field) {
// //   //   field.docs.asMap().forEach((index, data) {
// //   //     userSearchItemsx.addAll(field.docs()["name"]);
// //   //   });
// //   // });

// //   FirebaseFirestore.instance
// //       .collection("users")
// //       .where("idNum", whereIn: userSearchItemsName)
// //       .get()
// //       .then((querySnapshot) {
// //     querySnapshot.docs.forEach((result) {
// //       userSearchItemsx.add(result.data()["name"]);
// //     });
// //   });
// // }

// //search
// Container(
//                       height: 400,
//                       width: 480,
//                       child: ListView(children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               right: 10.0, left: 10, bottom: 10),
//                           child: TextField(
//                             onChanged: (email) {
//                               initiateSearch(email);
//                               setState(() {
//                                 isShown = false;
//                               });
//                             },
//                             controller: _emailTextController,
//                             decoration: InputDecoration(
//                                 // prefixIcon: IconButton(
//                                 //   color: Colors.black,
//                                 //   icon: Icon(Icons.arrow_back),
//                                 //   iconSize: 20.0,
//                                 //   onPressed: () {
//                                 //     // Navigator.of(context).pop();
//                                 //   },
//                                 // ),
//                                 contentPadding: EdgeInsets.only(left: 25.0),
//                                 hintText: 'Search by email',
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(4.0))),
//                           ),
//                         ),
//                         isShown
//                             ? Container()
//                             : GridView.count(
//                                 padding:
//                                     EdgeInsets.only(left: 10.0, right: 10.0),
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 4.0,
//                                 mainAxisSpacing: 4.0,
//                                 primary: false,
//                                 shrinkWrap: true,
//                                 children: tempSearchStore.map((element) {
//                                   return buildResultCard(element);
//                                 }).toList())
//                       ]),
//                     )
//                     // StreamBuilder<QuerySnapshot>(
//                     //   stream: getShop2(),
//                     //   builder: (BuildContext context,
//                     //       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     //     if (snapshot.hasError) {
//                     //       return Text('');
//                     //     } else if (snapshot.connectionState ==
//                     //         ConnectionState.done) {
//                     //       return Text('');
//                     //     } else {
//                     //       if (snapshot.data == null) {
//                     //         return Text('');
//                     //       } else {
//                     //         return Column(
//                     //             crossAxisAlignment: CrossAxisAlignment.stretch,
//                     //             children: [
//                     //               Padding(
//                     //                 padding: const EdgeInsets.only(
//                     //                     left: 15.0, right: 0.0, top: 20),
//                     //                 child: Row(
//                     //                   children: <Widget>[
//                     //                     Container(
//                     //                       width: 300,
//                     //                       child: Column(
//                     //                         crossAxisAlignment:
//                     //                             CrossAxisAlignment.stretch,
//                     //                         children: [
//                     //                           Text("Email"),
//                     //                           DropdownButton<String>(
//                     //                             items: snapshot.data.docs.map(
//                     //                                 (DocumentSnapshot
//                     //                                     document) {
//                     //                               return new DropdownMenuItem<
//                     //                                   String>(
//                     //                                 value: document["idNum"]
//                     //                                     .toString(),
//                     //                                 child: Text(
//                     //                                     document["email"]
//                     //                                         .toString()),
//                     //                               );
//                     //                             }).toList(),
//                     //                             value: dropdownValue,
//                     //                             hint: new Text("Email"),
//                     //                             elevation: 16,
//                     //                             isExpanded: true,
//                     //                             underline: Container(
//                     //                               height: 2,
//                     //                               color: Color(0xff93F9B9),
//                     //                             ),
//                     //                             onChanged: (String newValue) {
//                     //                               setState(() {
//                     //                                 dropdownValue = newValue;
//                     //                                 print(dropdownValue
//                     //                                     .toString());
//                     //                               });
//                     //                             },
//                     //                           ),
//                     //                         ],
//                     //                       ),
//                     //                     ),
//                     //                   ],
//                     //                 ),
//                     //               ),
//                     //             ]);
//                     //       }
//                     //     }
//                     //   },
//                     // ),

// Widget buildResultCard(data) {
//   return GestureDetector(
//     child: Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       elevation: 2.0,
//       child: Container(
//         child: Center(
//           child: Text(
//             data['email'],
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20.0,
//             ),
//           ),
//         ),
//       ),
//     ),
//     onTap: () {
//       print(data['email']);
//       setState(() {
//         _emailTextController.text = data['email'].toString();
//         isShown = true;
//         SystemChannels.textInput.invokeMethod('TextInput.hide');
//       });
//     },
//   );
// }
