// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_rekk/helpers/scanner_utils.dart';

import 'dart:ui' as ui;

enum Detector {
  label,
}

class CameraPreviewScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  CameraController _camera;
  Detector _currentDetector = Detector.label;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.back;

  final ImageLabeler _imageLabeler = FirebaseVision.instance.imageLabeler();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
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
      case Detector.label:
        return _imageLabeler.processImage;
    }

    return null;
  }

  Widget _buildResults() {
    const Text noResultsText = Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    switch (_currentDetector) {
      default:
        assert(_currentDetector == Detector.label ||
            _currentDetector == Detector.label);
        if (_scanResults is! List<ImageLabel>) return noResultsText;
        painter = LabelDetectorPainter(imageSize, _scanResults);
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    var size = MediaQuery.of(context).size.width;
    return Container(
      constraints: const BoxConstraints.expand(),
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
          : Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Stack(
                fit: StackFit.expand, //dont forget this shit
                children: <Widget>[
                  CameraPreview(_camera),
                  _buildResults(),
                ],
              ),
            ),
    );
  }

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _camera.stopImageStream();
    await _camera.dispose();

    setState(() {
      _camera = null;
    });

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ML Vision Example'),
      ),
      body: _buildImage(),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCameraDirection,
        child: _direction == CameraLensDirection.back
            ? const Icon(Icons.camera_front)
            : const Icon(Icons.camera_rear),
      ),
    );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _imageLabeler.close();
    });

    _currentDetector = null;
    super.dispose();
  }
}

class LabelDetectorPainter extends CustomPainter {
  LabelDetectorPainter(this.absoluteImageSize, this.labels);

  final Size absoluteImageSize;
  final List<ImageLabel> labels;

  @override
  void paint(Canvas canvas, Size size) {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 23.0,
          textDirection: TextDirection.ltr),
    );

    builder.pushStyle(ui.TextStyle(color: Colors.green));
    for (ImageLabel label in labels) {
      builder.addText('Label: ${label.text}, '
          'Confidence: ${label.confidence.toStringAsFixed(2)}\n');
    }
    builder.pop();

    canvas.drawParagraph(
      builder.build()
        ..layout(ui.ParagraphConstraints(
          width: size.width,
        )),
      const Offset(0.0, 0.0),
    );
  }

  @override
  bool shouldRepaint(LabelDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.labels != labels;
  }
}
