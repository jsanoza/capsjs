import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:ui' as ui;
import 'package:get_rekk/helpers/scanner_utils.dart';
import 'package:path_provider/path_provider.dart';

import 'package:torch_compat/torch_compat.dart';
import '../../main.dart';
import 'results.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
//   CameraController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = CameraController(cameras[0], ResolutionPreset.medium);
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<String> _takePicture() async {
//     if (!_controller.value.isInitialized) {
//       print("Controller is not initialized");
//       return null;
//     }

//     // Formatting Date and Time
//     String dateTime = DateFormat.yMMMd().addPattern('-').add_Hms().format(DateTime.now()).toString();

//     String formattedDateTime = dateTime.replaceAll(' ', '');
//     print("Formatted: $formattedDateTime");

//     final Directory appDocDir = await getApplicationDocumentsDirectory();
//     final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
//     await Directory(visionDir).create(recursive: true);
//     final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

//     if (_controller.value.isTakingPicture) {
//       print("Processing is progress ...");
//       return null;
//     }

//     try {
//       await _controller.takePicture(imagePath);
//     } on CameraException catch (e) {
//       print("Camera Exception: $e");
//       return null;
//     }

//     return imagePath;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ML Vision'),
//       ),
//       body: _controller.value.isInitialized
//           ? Stack(
//               children: <Widget>[
//                 CameraPreview(_controller),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Container(
//                     alignment: Alignment.bottomCenter,
//                     child: RaisedButton.icon(
//                       icon: Icon(Icons.camera),
//                       label: Text("Click"),
//                       onPressed: () async {
//                         await _takePicture().then((String path) {
//                           if (path != null) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DetailScreenx(path),
//                               ),
//                             );
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             )
//           : Container(
//               color: Colors.black,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//     );
//   }
// }

  CameraController controller;
  CameraController _camera;
  Detector _currentDetector = Detector.text;
  dynamic _scanResults;
  bool _isDetecting = false;
  bool _isTorchOn = false;
  CameraLensDirection _direction = CameraLensDirection.back;
  final TextRecognizer _recognizer = FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
    });
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _recognizer.close();
    });
    _currentDetector = null;
    // controller.dispose();
    // TorchCompat.dispose();
    super.dispose();
  }

  refresh() {
    setState(() {
      print('narefreshakoa');
      _initializeCamera();
    });
  }

  void _initializeCamera() async {
    final CameraDescription description = await ScannerUtils.getCamera(_direction);

    // _camera = CameraController(
    //   description,
    //   defaultTargetPlatform == TargetPlatform.iOS ? ResolutionPreset.medium : ResolutionPreset.medium,
    // );
    _camera = CameraController(cameras[0], ResolutionPreset.medium);
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          if (_currentDetector == null) return;
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Future<dynamic> Function(FirebaseVisionImage image) _getDetectionMethod() {
    switch (_currentDetector) {
      case Detector.text:
        return _recognizer.processImage;
    }

    return null;
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null || _camera == null || !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    switch (_currentDetector) {
      default:
        if (_scanResults is! VisionText) return noResultsText;
        painter = TextDetectorPainter1(imageSize, _scanResults);
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    // final size = MediaQuery.of(context).size;
    var size = MediaQuery.of(context).size.width;
    // final deviceRatio = size.width / size.height;
    return Container(
      // constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : Center(
              child: Container(
                width: size,
                height: size,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        width: size,
                        height: size / _camera.value.aspectRatio,
                        child: Stack(fit: StackFit.expand, children: <Widget>[CameraPreview(_camera), _buildResults()]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
      rotate: 0,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd().addPattern('-').add_Hms().format(DateTime.now()).toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    print("Formatted: $formattedDateTime");

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';
    final String tempPath = '$visionDir/image_$formattedDateTime+1.jpg';
    //set a temporary path to compressandgetfile for the image reader to read
    print('$imagePath.length' + 'hello2');
    if (_camera.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }
    try {
      // await _camera.takePicture(imagePath);
      print('OKAY');

      await controller.takePicture(imagePath);
      File file = File(imagePath);
      await testCompressAndGetFile(file, tempPath);
      if (_isTorchOn = true) {
        TorchCompat.turnOff();
        _isTorchOn = false;
      }
      print('$tempPath.length' + 'hello');
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return tempPath;
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(colors: [Color(0xff85D8CE), Color(0xff085078)], begin: const FractionalOffset(0.0, 0.0), end: const FractionalOffset(1.0, 1.0), stops: [0.0, 1.0], tileMode: TileMode.clamp),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 40,
              top: 70,
              child: Column(
                children: [
                  Text(
                    "Via Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontFamily: 'Nunito-Bold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildImage(),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 60),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff085078), // background
                        onPrimary: Colors.white, // foreground
                      ),
                      icon: Icon(Icons.camera),
                      label: Text("Take"),
                      onPressed: () async {
                        _camera.stopImageStream();
                        await _takePicture().then((String path) {
                          if (path != null) {
                            Get.to(DetailScreenx(
                              imagePath: path,
                              notifyList: refresh(),
                            ));
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => DetailScreenx(path)),
                            // );
                          }
                        });
                      },
                    ),
                    _isTorchOn
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff085078), // background
                              onPrimary: Colors.white, // foreground
                            ),
                            icon: Icon(Icons.flash_on),
                            label: Text("Flash"),
                            onPressed: () {
                              setState(() {
                                TorchCompat.turnOff();
                                _isTorchOn = false;
                              });
                            })
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff085078), // background
                              onPrimary: Colors.white, // foreground
                            ),
                            icon: Icon(Icons.flash_off),
                            label: Text("Flash"),
                            onPressed: () {
                              setState(() {
                                TorchCompat.turnOn();
                                _isTorchOn = true;
                              });
                            }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

var keys = ['APC', '7778', 'REGION', 'NCR', 'MC'];
var regex = new RegExp("\\b(?:${keys.join('|')})\\b", caseSensitive: false);

enum Detector {
  text,
}

// Paints rectangles around all the text in the image.
class TextDetectorPainter1 extends CustomPainter {
  TextDetectorPainter1(this.absoluteImageSize, this.visionText);

  final Size absoluteImageSize;

  final VisionText visionText;

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

    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(textAlign: TextAlign.left, fontSize: 23.0, textDirection: ui.TextDirection.ltr),
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    String pattern = r"^[A-Z]{0,4}[\s]*[0-9]{0,5}$";
    RegExp regEx = RegExp(pattern);
    String mailAddress = "";

    for (TextBlock block in visionText.blocks) {
      if (!regex.hasMatch(block.text)) {
        for (TextLine line in block.lines) {
          if (regEx.hasMatch(line.text)) {
            mailAddress = mailAddress + line.text;
            print(block.cornerPoints);
            // for (TextElement element in line.elements) {
            //   print(element.text);
            //   // paint.color = Colors.green;
            //   // canvas.drawRect(scaleRect(element), paint);
            //   //  builder.addText('\nelement: ${element.text}\n');
            //   // Util.uid = element.text + "\n";
            // }

            mailAddress = mailAddress + '\n';
            print(mailAddress);
            // paint.color = Colors.yellow;
            // canvas.drawRect(scaleRect(line), paint);
          }
        }
        paint.color = Colors.red;
        canvas.drawRect(scaleRect(block), paint);

        builder.pushStyle(ui.TextStyle(color: Colors.green));
        builder.addText('Plate: ${mailAddress.toString()} \n');
        builder.pop();

        canvas.drawParagraph(
          builder.build()
            ..layout(ui.ParagraphConstraints(
              width: size.width,
            )),
          const Offset(90.0, 410.0),
        );
      }
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter1 oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.visionText != visionText;
  }
}
