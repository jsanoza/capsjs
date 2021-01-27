import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:get_rekk/pages/cameratrial.dart';

class DetailScreenx extends StatefulWidget {
  final String imagePath;
  DetailScreenx(this.imagePath);

  @override
  _DetailScreenxState createState() => new _DetailScreenxState(imagePath);
}

class _DetailScreenxState extends State<DetailScreenx> {
  _DetailScreenxState(this.path);

  final String path;

  Size _imageSize;
  List<TextElement> _elements = [];
  List<TextBlock> _blocks = [];
  String recognizedText = "Loading ...";

  void _initializeVision() async {
    final File imageFile = File(path);
    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    String pattern = r"^[A-Z]{0,4}[\s]*[0-9]{0,5}$";
    RegExp regEx = RegExp(pattern);

    var keys = ['APC', '7778', 'REGION', 'NCR', 'MC', 'POGI', 'LANG', 'TAKBO'];
    var regex1 = new RegExp("\\b(?:${keys.join('|')})\\b", caseSensitive: false);

    String mailAddress = "";
    for (TextBlock block in visionText.blocks) {
      
      for (TextLine line in block.lines) {
        if (!regex1.hasMatch(line.text)) {
         
          if(regEx.hasMatch(line.text)){
          mailAddress = mailAddress + line.text;
          for (TextElement element in line.elements) {
            setState(() {
              _elements.add(element);
              _blocks.add(block);
              // mailAddress = Util.uid.toString();
            });
          }
          mailAddress = mailAddress + '\n';
          }
        }
      }
    }

    if (this.mounted) {
      setState(() {
        recognizedText = mailAddress;
        print('recognized' + recognizedText) ;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.to(CameraApp(), transition: Transition.fadeIn),
        // ),
      ),
      body: _imageSize != null
          ? Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.maxFinite,
                    color: Colors.black,
                    child: CustomPaint(
                      foregroundPainter:
                          TextDetectorPainter(_imageSize, _blocks),
                      child: AspectRatio(
                        aspectRatio: _imageSize.aspectRatio,
                        child: Image.file(
                          File(path),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 8.0),
                          //   child: Text(
                          //     "Identified Plates",
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            height: 100,
                            child: SingleChildScrollView(
                              child: Text(
                                recognizedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.blocks);

  final Size absoluteImageSize;
  // final List<TextElement> elements;

  final List<TextBlock> blocks;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextBlock block in blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          print(element.text);
        }
        // paint.color = Colors.yellow;
        // canvas.drawRect(scaleRect(line), paint);
      }
      paint.color = Colors.red;
      canvas.drawRect(scaleRect(block), paint);
    }
    //old
    // for (TextElement element in elements) {
    //   canvas.drawRect(scaleRect(element), paint);
    // }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
