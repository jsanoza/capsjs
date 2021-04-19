import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/vehiclelist.dart';
import 'package:uuid/uuid.dart';

import '../loginsignup.dart';
import 'foundlist.dart';
import 'fourth.dart';

class NewVehicle extends StatefulWidget {
  @override
  _NewVehicleState createState() => _NewVehicleState();
}

class _NewVehicleState extends State<NewVehicle>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  TabController _tabController;
  bool isMenuOpen = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid();

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 25;
    double contLimit = position.dy + renderBox.size.height - 25;
    double step = (contLimit - start) / 6;
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });
  }

  double getSize(int x) {
    double size =
        (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 12;
    return size;
  }

  signOut() {
    User user = auth.currentUser;
    var collectionid2 = uuid.v1();

    FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
      'lastactivity_datetime': Timestamp.now(),
    }).then((value) {
      FirebaseFirestore.instance
          .collection('usertrail')
          .doc(user.uid)
          .collection('trail')
          .doc(collectionid2)
          .set({
        'userid': user.uid,
        'activity': 'Logged out session.',
        'editcreate_datetime': Timestamp.now(),
      });
    }).then((value) {
      auth.signOut();
      Get.offAll(LogSign());
    });
  }

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sidebarSize = Get.width * 0.60;
    double menuContainerHeight = Get.height / 2;

    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Stack(children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              isMenuOpen = false;
            });
          },
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  // automaticallyImplyLeading: false,
                  // title:
                  // Allows the user to reveal the app bar if they begin scrolling back
                  // up the list of items.
                  leading: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Get.offAll(Fourth());
                    },
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Color(0xff085078),

                  floating: true,
                  pinned: true,
                  snap: false,

                  shadowColor: Colors.green,

                  // Display a placeholder widget to visualize the shrinking size.
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Vehicles",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Nunito-Bold'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: AvatarGlow(
                                startDelay: Duration(milliseconds: 0),
                                glowColor: Colors.red,
                                endRadius: 40.0,
                                duration: Duration(milliseconds: 2000),
                                repeat: true,
                                showTwoGlows: true,
                                repeatPauseDuration: Duration(milliseconds: 0),
                                child: IconButton(
                                  iconSize: 25.0,
                                  icon: Icon(Icons.menu),
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      isMenuOpen = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      background: Image.network(
                        'https://www.spiritinbusiness.org/wp-content/uploads/2019/08/images1101-5d67f83b74973-737x415.jpg',
                        fit: BoxFit.cover,
                      )),
                  // Make the initial height of the SliverAppBar larger than normal.
                  expandedHeight: 200,
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Active List"),
                        Tab(text: "Found"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              // controller: _tabController,
              children: [
                VehicleList(),
                // Ongoingsched(),
                // UpcomingState(),
                // OngoingdetailsPagetwo(),
                // OngoingdetailsPageone(),
                // const Center(
                //   child: Text('Display Tab 1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                // ),
                FoundList(),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 1500),
          //gawing + 1 if gusto mo may nakalitaw
          //pero much better looking if + 0
          left: isMenuOpen ? 0 : -sidebarSize + 0,
          top: 0,
          curve: Curves.elasticOut,
          child: SizedBox(
            width: sidebarSize,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.localPosition.dx <= sidebarSize) {
                  setState(() {
                    _offset = details.localPosition;
                  });
                }

                if (details.localPosition.dx > sidebarSize - 20 &&
                    details.delta.distanceSquared > 2) {
                  setState(() {
                    isMenuOpen = true;
                  });
                }
              },
              onPanEnd: (details) {
                setState(() {
                  _offset = Offset(0, 0);
                });
              },
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size(sidebarSize, Get.height),
                    painter: DrawerPainter(offset: _offset),
                  ),
                  Container(
                    height: Get.height,
                    width: sidebarSize,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: Get.height * 0.30,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 120,
                                  width: 120,
                                  // padding: EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(UserLog.ppUrl),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: Text(
                                    UserLog.rank +
                                        '. ' +
                                        UserLog.fullName.toUpperCase(),
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Container(
                          key: globalKey,
                          width: double.infinity,
                          height: menuContainerHeight,
                          child: Column(
                            children: <Widget>[
                              MyButton(
                                  text: "Schedule Details",
                                  iconData: Icons.text_snippet,
                                  textSize: getSize(0),
                                  height: (menuContainerHeight) / 5,
                                  selectedIndex: 0),
                              // MyButton(text: "Upgrade User Position", iconData: Icons.upgrade, textSize: getSize(1), height: (menuContainerHeight) / 6, selectedIndex: 4),
                              MyButton(
                                  text: "Add Schedule",
                                  iconData: Icons.library_add_check,
                                  textSize: getSize(1),
                                  height: (menuContainerHeight) / 5,
                                  selectedIndex: 1),
                              // MyButton(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(3), height: (menuContainerHeight) / 6, selectedIndex: 2),
                              // MyButton(text: "Reset User Password", iconData: Icons.local_car_wash, textSize: getSize(4), height: (menuContainerHeight) / 6, selectedIndex: 3),

                              // MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                              // MyButton(
                              //     text: "Fourth",
                              //     iconData: Icons.settings,
                              //     textSize: getSize(4),
                              //     height: (menuContainerHeight) / 5,
                              //     selectedIndex: 4),
                              MyButton(
                                  text: "Edit Info",
                                  iconData: Icons.app_registration,
                                  textSize: getSize(2),
                                  height: (menuContainerHeight) / 5,
                                  selectedIndex: 2),
                              MyButton(
                                  text: "Manage Users",
                                  iconData: Icons.settings_applications,
                                  textSize: getSize(3),
                                  height: (menuContainerHeight) / 5,
                                  selectedIndex: 3),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              // auth.signOut();
                              // Get.offAll(LogSign());
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Logout Confirmation"),
                                      content: const Text(
                                          "Are you sure you want to log out?"),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () => {
                                                  signOut(),
                                                },
                                            child: const Text("Yes")),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    );
                                  });
                              print('clik');
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Color(0xff085078),
                                  size: 20.0,
                                ),
                                Text(
                                  '  Logout',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Nunito-Bold'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
