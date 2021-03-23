import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:get_rekk/helpers/navbuttonusers.dart';
import 'package:get_rekk/helpers/util.dart';
import 'package:get_rekk/pages/foradmin/ongoingdetailspageone.dart';
import 'package:get_rekk/pages/foradmin/ongoingdetailspagetwo.dart';
import 'package:get_rekk/pages/forusers/usersongoingdetailspageone.dart';
import 'package:get_rekk/pages/forusers/usersongoingdetailspagetwo.dart';

class UsersOngoingDetailsPage extends StatefulWidget {
  @override
  _UsersOngoingDetailsPage createState() => _UsersOngoingDetailsPage();
}

class _UsersOngoingDetailsPage extends State<UsersOngoingDetailsPage> with SingleTickerProviderStateMixin {
  @override
  // ignore: override_on_non_overriding_member
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  TabController _tabController;
  bool isMenuOpen = false;

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
    double size = (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 12;
    return size;
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
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  // automaticallyImplyLeading: false,
                  // title:
                  // Allows the user to reveal the app bar if they begin scrolling back
                  // up the list of items.
                  leading: BackButton(color: Colors.white),
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
                                "Ongoing",
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
                        'https://media.gettyimages.com/videos/crowds-and-police-background-video-id1141798934?s=640x640',
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
                        Tab(text: "Live Activity Feed"),
                        Tab(text: "Details"),
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
                // Ongoingsched(),
                // UpcomingState(),
                UsersOngoingdetailsPagetwo(),
                UsersOngoingdetailsPageone(),
                // const Center(
                //   child: Text('Display Tab 1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              MyButton2(text: "User Schedule", iconData: Icons.text_snippet, textSize: getSize(0), height: (menuContainerHeight) / 5, selectedIndex: 0),
                              MyButton2(text: "Edit Info", iconData: Icons.edit, textSize: getSize(1), height: (menuContainerHeight) / 5, selectedIndex: 1),
                              // MyButton2(text: "OCR", iconData: Icons.camera, textSize: getSize(2), height: (menuContainerHeight) / 5, selectedIndex: 2),
                              // MyButton(text: "Third Page", iconData: Icons.attach_file, textSize: getSize(3), height: (menuContainerHeight) / 5, selectedIndex: 3),
                              // MyButton(
                              //     text: "Fourth",
                              //     iconData: Icons.settings,
                              //     textSize: getSize(4),
                              //     height: (menuContainerHeight) / 5,
                              //     selectedIndex: 4),
                            ],
                          ),
                        )
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
