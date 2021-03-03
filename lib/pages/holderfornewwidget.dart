// return SafeArea(
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20),
//               child: Container(
//                 width: 365,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: new BorderRadius.circular(10.0),
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(.40), blurRadius: 30, spreadRadius: 1)],
//                 ),
//                 child: SafeArea(
//                   child: Container(
//                     child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           //here ang contents
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0, bottom: 40),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Container(
//                                   width: 40,
//                                   height: 30,
//                                   child: RaisedButton(
//                                     onPressed: () {
//                                       previousPage();
//                                       // Get.to(LocationMaps());
//                                     }, //only after checking
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: Ink(
//                                       decoration: const BoxDecoration(
//                                         gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
//                                         borderRadius: BorderRadius.all(Radius.circular(80.0)),
//                                       ),
//                                       child: Container(
//                                         constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
//                                         alignment: Alignment.center,
//                                         child: Icon(Icons.arrow_left_outlined, size: 20, color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Container(
//                                   height: 30,
//                                   width: 40,
//                                   child: RaisedButton(
//                                     onPressed: () {
//                                       nextPage();
//                                       // Get.to(LocationMaps());
//                                     }, //only after checking
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: Ink(
//                                       decoration: const BoxDecoration(
//                                         gradient: LinearGradient(colors: [Color(0xff93F9B9), Color(0xff1D976C)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
//                                         borderRadius: BorderRadius.all(Radius.circular(80.0)),
//                                       ),
//                                       child: Container(
//                                         constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
//                                         alignment: Alignment.center,
//                                         child: Icon(Icons.arrow_right_outlined, size: 20, color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
