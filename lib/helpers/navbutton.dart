import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_rekk/pages/dashboard.dart';
import 'package:get_rekk/pages/first.dart';
import 'package:get_rekk/pages/fourth.dart';
import 'package:get_rekk/pages/second.dart';
import 'package:get_rekk/pages/third.dart';

class MyButton extends StatefulWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;
  int selectedIndex = 0;

  MyButton(
      {this.text,
      this.iconData,
      this.textSize,
      this.height,
      this.selectedIndex});

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              widget.iconData,
              color: Colors.lightGreen,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: widget.textSize,
                  fontFamily: 'Nunito-Bold'),
            ),
          ],
        ),
        onPressed: () {
          switch (widget.selectedIndex) {
            case 0:
              print('Zero');
              Get.offAll(Dashboard(), transition: Transition.native);
              break;

            case 1:
              print('One');
             Get.offAll(First(), transition: Transition.native);
              break;

            case 2:
              print('Two');
              Get.offAll(Second(), transition: Transition.native);
              break;

            case 3:
              print('Three');
              Get.offAll(Third(), transition: Transition.native);
              break;

            case 4:
              print('Four');
              Get.offAll(Fourth(), transition: Transition.native);
              break;

            default:
              print('Index Not Found');
          }
        });
  }
}

class DrawerPainter extends CustomPainter {
  final Offset offset;

  DrawerPainter({this.offset});

  double getControlPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getControlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
