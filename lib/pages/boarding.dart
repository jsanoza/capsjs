import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_rekk/helpers/strings.dart';
import 'package:get_rekk/pages/loginsignup.dart';

class Boarding extends StatefulWidget {
  @override
  _BoardingState createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff85D8CE), Color(0xff085078)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                PageView(
                  onPageChanged: (int page) {
                    setState(() {
                      currentIndex = page;
                    });
                  },
                  controller: _pageController,
                  children: <Widget>[
                    makePage(image: 'assets/images/pol8.png', title: Strings.stepOneTitle, content: Strings.stepOneContent),
                    makePage(reverse: true, image: 'assets/images/pol9.png', title: Strings.stepTwoTitle, content: Strings.stepTwoContent),
                    makePage(image: 'assets/images/pol6.png', title: Strings.stepThreeTitle, content: Strings.stepThreeContent),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator(),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 40.0,
                icon: Icon(Icons.keyboard_arrow_right),
                color: Colors.white,
                onPressed: () {
                  // Navigator.push(context, ScaleRoute(page: LoginPage()));
                  Get.offAll(LogSign(), transition: Transition.fade);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse
              ? Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(image),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w500),
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w500),
          ),
          reverse
              ? Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(image),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}
