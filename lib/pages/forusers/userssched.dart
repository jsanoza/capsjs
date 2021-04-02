import 'dart:async';
import 'dart:math';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/navbuttonusers.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/ongoingsched.dart';
import 'package:get_rekk/pages/foradmin/passsched.dart';
import 'package:get_rekk/pages/foradmin/upcomsched.dart';
import 'package:get_rekk/pages/forchat/chat_screen.dart';
import 'package:get_rekk/pages/forusers/usersongoing.dart';
import 'package:get_rekk/pages/forusers/userspasssched.dart';
import 'package:get_rekk/pages/forusers/usersupcomsched.dart';
import 'package:get_rekk/pages/loginsignup.dart';
import 'package:uuid/uuid.dart';

class UsersSched extends StatefulWidget {
  @override
  _UsersSchedState createState() => _UsersSchedState();
}

FirebaseAuth auth = FirebaseAuth.instance;
User user = auth.currentUser;

class _UsersSchedState extends State<UsersSched> with SingleTickerProviderStateMixin {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  TabController _tabController;
  bool isMenuOpen = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  var uuid = Uuid();
  String badge;

  @override
  void initState() {
    // getBadge();
    // check();
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  // Future getBadge() async {
  //   String collectid;

  //   var a = await FirebaseFirestore.instance.collection('users').where("collectionId", isEqualTo: user.uid).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     collectid = hello.data()['badgeNum'];
  //     UserSched.badge = collectid;
  //     UserSched.badgename = hello.data()['fullName'];
  //     print(UserSched.badge);
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getCheckBlock(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('blockteam', arrayContains: UserSched.badge).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);
  //     print(UserSched.collectid);
  //     // print("yes");
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getCheckSecu(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('secuteam', arrayContains: UserSched.badge).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getCheckInvest(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('investteam', arrayContains: UserSched.badge).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getCheckSearch(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('searchteam', arrayContains: UserSched.badge).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getTeamlead(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('teamlead', isEqualTo: UserSched.badgename).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);

  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('schedule').doc(hello.data()['collectionid']).set({
  //       // 'collectionid2': collectionid2,
  //       'scheduleuid': hello.data()['collectionid']
  //     });
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getSpotter(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('spotter', isEqualTo: UserSched.badgename).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future getSpokesperson(String badge) async {
  //   var a = await FirebaseFirestore.instance.collection('schedule').where('spokesperson', isEqualTo: UserSched.badgename).get();
  //   if (a.docs.isNotEmpty) {
  //     var hello = a.docs[0];
  //     UserSched.collectid.add(hello.data()['collectionid']);
  //     return true;
  //   }
  //   if (a.docs.isEmpty) {
  //     return false;
  //   }
  // }

  // Future check() async {
  //   var checkBlock = await getCheckBlock(UserSched.badge);
  //   print(checkBlock);
  //   var checkSecu = await getCheckSecu(UserSched.badge);
  //   print(checkSecu);
  //   var checkInvest = await getCheckInvest(UserSched.badge);
  //   print(checkInvest);
  //   var checkSearch = await getCheckSearch(UserSched.badge);
  //   print(checkSearch);
  //   var checkTeamlead = await getTeamlead(UserSched.badge);
  //   print(checkTeamlead);
  //   var checkSpotter = await getSpotter(UserSched.badge);
  //   print(checkSpotter);
  //   var checkSpokesperson = await getSpokesperson(UserSched.badge);
  //   print(checkSpokesperson);
  //   if (UserSched.collectid.length == 0) {
  //     print('walanglaman');
  //     UserSched.collectid.add('02391872');
  //   }

  //   // Timer(Duration(seconds: 3), () {
  //   //   Get.offAll(UsersSched());
  //   // });

  //   print(UserSched.collectid);
  // }

  signOut() {
    User user = auth.currentUser;
    var collectionid2 = uuid.v1();

    FirebaseFirestore.instance.collection('usertrail').doc(user.uid).set({
      'lastactivity_datetime': Timestamp.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection('usertrail').doc(user.uid).collection('trail').doc(collectionid2).set({
        'userid': user.uid,
        'activity': 'Logged out session.',
        'editcreate_datetime': Timestamp.now(),
      });
    }).then((value) {
      auth.signOut();
      Get.offAll(LogSign());
    });
  }

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
    double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 15 : 12;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    double sidebarSize = Get.width * 0.60;
    double menuContainerHeight = Get.height / 2;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  isMenuOpen = false;
                });
              },
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      // title:
                      // Allows the user to reveal the app bar if they begin scrolling back
                      // up the list of items.
                      brightness: Brightness.light,
                      backgroundColor: Color(0xff085078),
                      floating: true,
                      pinned: true,
                      snap: true,
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
                                    "Schedules",
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Nunito-Bold'),
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
                            'https://khspress.com/wp-content/uploads/2019/11/6.jpg',
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
                            Tab(text: "Ongoing"),
                            Tab(text: "Future"),
                            Tab(text: "Past"),
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
                    UsersOngoingSched(),
                    UsersUpcomingState(),
                    UsersPassschedState(),

                    // const Center(
                    //   child: Text('Display Tab 3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    // ),
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

                    if (details.localPosition.dx > sidebarSize - 20 && details.delta.distanceSquared > 2) {
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
                        painter: DrawerPainter2(offset: _offset),
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
                                        backgroundImage: NetworkImage(UserLog.ppUrl),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: Text(
                                        UserLog.rank + '. ' + UserLog.fullName.toUpperCase(),
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
                                  MyButton2(text: "Edit Info", iconData: Icons.edit, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 1),
                                  // MyButton2(text: "Message", iconData: Icons.message, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                  // MyButton2(text: "Register New User", iconData: Icons.app_registration, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 2),
                                  // MyButton(text: "Reset Users Password", iconData: Icons.replay, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                  // MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                                  // MyButton(
                                  //     text: "Fourth",
                                  //     iconData: Icons.settings,
                                  //     textSize: getSize(4),
                                  //     height: (menuContainerHeight) / 5,
                                  //     selectedIndex: 4),
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
                                          content: const Text("Are you sure you want to log out?"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () => {
                                                      signOut(),
                                                    },
                                                child: const Text("Yes")),
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
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
                                      size: 25.0,
                                    ),
                                    Text(
                                      '  Logout',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Nunito-Bold'),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ChatScreen(
            wherefrom: 'dash',
          ));
          // Add your onPressed code here!
        },
        child: const Icon(
          Icons.message,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff085078),
      ),
    );
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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

class TabA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, child) => Divider(
          height: 1,
        ),
        padding: EdgeInsets.all(0.0),
        itemCount: 30,
        itemBuilder: (context, i) {
          return Container(
            height: 100,
            width: double.infinity,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          );
        },
      ),
    );
  }
}
