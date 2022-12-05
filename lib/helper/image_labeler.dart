import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageLabelerSingleton {
  late final ImageLabelerSingleton _imageLabeler;
  ImageLabelerSingleton._privateConstructor();

  static final ImageLabelerSingleton _instance = ImageLabelerSingleton._privateConstructor();

  factory ImageLabelerSingleton() {
    return _instance;
  }

  Future<void> init() async {
    const path = "assets/ml/object_labeler.tflite";
    final modelPath = await _getModel(path);
    final options = LocalLabelerOptions(modelPath: modelPath);
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
