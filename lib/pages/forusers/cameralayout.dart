import 'package:flutter/material.dart';

class CameraLayout extends StatefulWidget {
  @override
  _CameraLayoutState createState() => _CameraLayoutState();
}

class _CameraLayoutState extends State<CameraLayout> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1D976C),
          // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).popUntil((_) => count++ >= 2)),
          title: Text(
            "Capture",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [],
          ),
        ),
      ),
    );
  }
}
