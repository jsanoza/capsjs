// import 'dart:math';

// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_rekk/helpers/navbutton.dart';
// import 'package:get_rekk/pages/upcomsched.dart';

// class Fourth extends StatefulWidget {
//   @override
//   _FourthState createState() => _FourthState();
// }

// class _FourthState extends State<Fourth> with SingleTickerProviderStateMixin {
//   @override
//   // ignore: override_on_non_overriding_member
//   Offset _offset = Offset(0, 0);
//   GlobalKey globalKey = GlobalKey();
//   List<double> limits = [];
//   TabController _tabController;
//   bool isMenuOpen = false;

//   @override
//   void initState() {
//     limits = [0, 0, 0, 0, 0, 0];
//     WidgetsBinding.instance.addPostFrameCallback(getPosition);
//     _tabController = TabController(
//       initialIndex: 0,
//       length: 3,
//       vsync: this,
//     );
//     super.initState();
//   }

//   getPosition(duration) {
//     RenderBox renderBox = globalKey.currentContext.findRenderObject();
//     final position = renderBox.localToGlobal(Offset.zero);
//     double start = position.dy - 25;
//     double contLimit = position.dy + renderBox.size.height - 25;
//     double step = (contLimit - start) / 6;
//     limits = [];
//     for (double x = start; x <= contLimit; x = x + step) {
//       limits.add(x);
//     }
//     setState(() {
//       limits = limits;
//     });
//   }

//   double getSize(int x) {
//     double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 12;
//     return size;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double sidebarSize = Get.width * 0.60;
//     double menuContainerHeight = Get.height / 2;

//     return Scaffold(
//         body: DefaultTabController(
//       length: 3,
//       child: Stack(children: <Widget>[
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isMenuOpen = false;
//             });
//           },
//           child: NestedScrollView(
//             headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                   // title:
//                   // Allows the user to reveal the app bar if they begin scrolling back
//                   // up the list of items.
//                   brightness: Brightness.light,
//                   backgroundColor: Color(0xff1D976C),
//                   floating: true,
//                   pinned: true,
//                   snap: true,
//                   shadowColor: Colors.green,
//                   // Display a placeholder widget to visualize the shrinking size.
//                   flexibleSpace: FlexibleSpaceBar(
//                       centerTitle: true,
//                       title: Padding(
//                         padding: const EdgeInsets.only(top: 30.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text(
//                                 "Schedules",
//                                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 1.0),
//                               child: AvatarGlow(
//                                 startDelay: Duration(milliseconds: 0),
//                                 glowColor: Colors.lime,
//                                 endRadius: 40.0,
//                                 duration: Duration(milliseconds: 2000),
//                                 repeat: true,
//                                 showTwoGlows: true,
//                                 repeatPauseDuration: Duration(milliseconds: 0),
//                                 child: IconButton(
//                                   iconSize: 25.0,
//                                   icon: Icon(Icons.menu),
//                                   color: Colors.white,
//                                   onPressed: () {
//                                     setState(() {
//                                       isMenuOpen = true;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       background: Image.network(
//                         'https://cloudfront-us-east-1.images.arcpublishing.com/cmg/PZQVBPFW2FXTEMMO2EVXFTEXJA.jpg',
//                         fit: BoxFit.cover,
//                       )),
//                   // Make the initial height of the SliverAppBar larger than normal.
//                   expandedHeight: 200,
//                 ),
//                 SliverPersistentHeader(
//                   delegate: _SliverAppBarDelegate(
//                     TabBar(
//                       labelColor: Colors.black87,
//                       unselectedLabelColor: Colors.grey,
//                       tabs: [
//                         Tab(text: "Future"),
//                         Tab(text: "Past"),
//                         Tab(text: "Tab 3"),
//                       ],
//                     ),
//                   ),
//                   pinned: true,
//                 ),
//               ];
//             },
//             body: TabBarView(
//               // controller: _tabController,
//               children: [
//                 UpcomingState(),
//                 TabA(),
//                 const Center(
//                   child: Text('Display Tab 3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         AnimatedPositioned(
//           duration: Duration(milliseconds: 1500),
//           left: isMenuOpen ? 0 : -sidebarSize + 1,
//           top: 0,
//           curve: Curves.elasticOut,
//           child: SizedBox(
//             width: sidebarSize,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 if (details.localPosition.dx <= sidebarSize) {
//                   setState(() {
//                     _offset = details.localPosition;
//                   });
//                 }

//                 if (details.localPosition.dx > sidebarSize - 20 && details.delta.distanceSquared > 2) {
//                   setState(() {
//                     isMenuOpen = true;
//                   });
//                 }
//               },
//               onPanEnd: (details) {
//                 setState(() {
//                   _offset = Offset(0, 0);
//                 });
//               },
//               child: Stack(
//                 children: <Widget>[
//                   CustomPaint(
//                     size: Size(sidebarSize, Get.height),
//                     painter: DrawerPainter(offset: _offset),
//                   ),
//                   Container(
//                     height: Get.height,
//                     width: sidebarSize,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         Container(
//                           height: Get.height * 0.30,
//                           child: Center(
//                             child: Column(
//                               children: <Widget>[
//                                 Image.asset(
//                                   "assets/images/hospital.png",
//                                   width: sidebarSize / 2,
//                                 ),
//                                 Text(
//                                   "Big PP",
//                                   style: TextStyle(color: Colors.black45),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Divider(
//                           thickness: 1,
//                         ),
//                         Container(
//                           key: globalKey,
//                           width: double.infinity,
//                           height: menuContainerHeight,
//                           child: Column(
//                             children: <Widget>[
//                               MyButton(text: "Home", iconData: Icons.person, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 0),
//                               MyButton(text: "First Page", iconData: Icons.payment, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 1),
//                               MyButton(text: "Second Page", iconData: Icons.notifications, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 2),
//                               MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
//                               // MyButton(
//                               //     text: "Fourth",
//                               //     iconData: Icons.settings,
//                               //     textSize: getSize(4),
//                               //     height: (menuContainerHeight) / 5,
//                               //     selectedIndex: 4),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ]),
//     ));
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate(this._tabBar);

//   final TabBar _tabBar;

//   @override
//   double get minExtent => _tabBar.preferredSize.height;
//   @override
//   double get maxExtent => _tabBar.preferredSize.height;

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return new Container(
//       color: Colors.white,
//       child: _tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }

// class TabA extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scrollbar(
//       child: ListView.separated(
//         separatorBuilder: (context, child) => Divider(
//           height: 1,
//         ),
//         padding: EdgeInsets.all(0.0),
//         itemCount: 30,
//         itemBuilder: (context, i) {
//           return Container(
//             height: 100,
//             width: double.infinity,
//             color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
//           );
//         },
//       ),
//     );
//   }
// }
