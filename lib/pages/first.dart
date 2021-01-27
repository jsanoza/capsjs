import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/navbutton.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];

  bool isMenuOpen = false;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
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
    double size =
        (_offset.dy > limits[x] && _offset.dy < limits[x + 1]) ? 25 : 12;
    return size;
  }

  Widget _buildSignupbtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Stack(
        children: <Widget>[
          Center(
              child: Container(
            child: RoundedLoadingButton(
              color: Color(0xff1D976C),
              child: Text('Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito-Regular',
                      fontSize: 18)),
              controller: _btnController,
              onPressed: () {
                _btnController.success();
                // Get.to(HomeView());
              },
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double sidebarSize = Get.width * 0.60;
    double menuContainerHeight = Get.height / 2;

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        setState(() {
          isMenuOpen = false;
        });
      },
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xff93F9B9), Color(0xff1D976C)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          height: Get.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 40),
                          child: Text(
                            "1st",
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Nunito-Bold'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: AvatarGlow(
                              startDelay: Duration(milliseconds: 0),
                              glowColor: Colors.lime,
                              endRadius: 40.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 0),
                              child: IconButton(
                                iconSize: 40.0,
                                icon: Icon(Icons.bubble_chart),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isMenuOpen = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: _buildSignupbtn(),
                    ),

                    ///here
                  ],
                ),
              ),

              //here starts of the animation and navigation bar
              AnimatedPositioned(
                duration: Duration(milliseconds: 1500),
                left: isMenuOpen ? 0 : -sidebarSize + 1,
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
                                      Image.asset(
                                        "assets/images/hospital.png",
                                        width: sidebarSize / 2,
                                      ),
                                      Text(
                                        "Big PP",
                                        style: TextStyle(color: Colors.black45),
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
                                        text: "Home",
                                        iconData: Icons.person,
                                        textSize: getSize(0),
                                        height: (menuContainerHeight) / 5,
                                        selectedIndex: 0),
                                    // MyButton(
                                    //     text: "First Page",
                                    //     iconData: Icons.payment,
                                    //     textSize: getSize(1),
                                    //     height: (menuContainerHeight) / 5,
                                    //     selectedIndex: 1),
                                    MyButton(
                                        text: "Second Page",
                                        iconData: Icons.notifications,
                                        textSize: getSize(2),
                                        height: (menuContainerHeight) / 5,
                                        selectedIndex: 2),
                                    MyButton(
                                        text: "Third Page",
                                        iconData: Icons.attach_file,
                                        textSize: getSize(3),
                                        height: (menuContainerHeight) / 5,
                                        selectedIndex: 3),
                                    MyButton(
                                        text: "Fourth",
                                        iconData: Icons.settings,
                                        textSize: getSize(4),
                                        height: (menuContainerHeight) / 5,
                                        selectedIndex: 4),
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
            ],
          ),
        ),
      ),
    ));
  }
}
